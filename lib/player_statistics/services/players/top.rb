# frozen_string_literal: true

require_relative '../mixins/filter'

module PlayerStatistics
  module Services
    module Players
      class Top
        include Mixins::Filter

        def self.call(performance, team = nil)
          new(performance, team).call
        end

        def initialize(performance, team)
          @performance = performance
          @team        = team
        end

        def call
          top5_dataset.all
        end

        private

        TOP5_DATASET =
          Models::Performance
          .select(
            Sequel.lit('full_name, COUNT(performance_id) as performed_times')
          )
          .join(:line_ups_players_performances, performance_id: :id)
          .join(:players, id: :player_id)
          .group(Sequel[:players][:id])
          .order(:performed_times.desc)
          .limit(5)
          .naked

        def top5_dataset
          dataset = TOP5_DATASET
                    .where(Sequel[:players][:id] => players_per_team_dataset)
          with_performance_filter(dataset)
        end

        PLAYERS_PER_TEAM_DATASET =
          Models::Player
          .select(Sequel.lit('unnest(ARRAY_AGG(DISTINCT players.id))'))
          .join(:line_ups_players, player_id: :id)
          .join(:line_ups, id: :line_up_id)
          .join(:teams, id: :team_id)
          .group(Sequel[:teams][:id])

        def players_per_team_dataset
          dataset = with_team_filter(PLAYERS_PER_TEAM_DATASET)
          Sequel.function(:ANY, dataset)
        end

        def with_team_filter(dataset)
          return dataset unless @team
          dataset.where(
            filter(:teams, :name, @team)
          )
        end

        def with_performance_filter(dataset)
          dataset.where(
            filter(:performances, :description, @performance)
          )
        end
      end
    end
  end
end
