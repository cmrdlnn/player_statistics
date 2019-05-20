# frozen_string_literal: true

require_relative '../mixins/filter'

module PlayerStatistics
  module Services
    module Players
      class CheckPerformance
        include Mixins::Filter

        def self.call(player, game, performance)
          new(player, game, performance).call
        end

        def initialize(player, game, performance)
          @player      = player
          @game        = game
          @performance = performance
        end

        DATASET =
          Models::Performance
          .select(Sequel[:performances][:id])
          .join(:line_ups_players_performances, performance_id: :id)
          .join(:players, id: :player_id)
          .join(
            :games,
            Sequel.|(
              { line_up_id: :line_up_1_id },
              { line_up_id: :line_up_2_id }
            )
          )
          .naked

        def call
          !with_filters(DATASET).first.nil?
        end

        def with_filters(dataset)
          dataset.where(filter(:players, :full_name, @player))
                 .where(filter(:games, :description, @game))
                 .where(filter(:performances, :description, @performance))
        end
      end
    end
  end
end
