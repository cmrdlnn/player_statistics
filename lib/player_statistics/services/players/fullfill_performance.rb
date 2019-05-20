# frozen_string_literal: true

require_relative '../mixins/filter'
require_relative 'fullfill_performance/errors'

module PlayerStatistics
  module Services
    module Players
      class FullfillPerformance
        include Mixins::Filter

        def self.call(player, game, performance)
          new(player, game, performance).call
        end

        def initialize(player, game, performance)
          @player      = player
          @game        = game
          @performance = performance
        end

        def call
          performance_id        = find_performance!.id
          line_up_id, player_id = find_player_and_line_up!
                                  .values_at(:line_up_id, :player_id)
          fullfill_performance(player_id, line_up_id, performance_id)
        end

        private

        def fullfill_performance(player_id, line_up_id, performance_id)
          Sequel::Model.db[:line_ups_players_performances].insert(
            %i[player_id line_up_id performance_id],
            [player_id, line_up_id, performance_id]
          )
        rescue Sequel::UniqueConstraintViolation
          raise Errors::AlreadyFullfilled, [@player, @game, @performance]
        end

        DATASET =
          Models::Player
          .select(:player_id, :line_up_id)
          .join(:line_ups_players, player_id: :id)
          .join(
            :games,
            Sequel.|(
              { line_up_id: :line_up_1_id },
              { line_up_id: :line_up_2_id }
            )
          )
          .naked

        def find_player_and_line_up!
          player_and_game = with_player_and_game_filter(DATASET).first
          return player_and_game if player_and_game
          raise Errors::PlayerGameMissing, [@player, @game]
        end

        def with_player_and_game_filter(dataset)
          dataset.where(filter(:players, :full_name, @player))
                 .where(filter(:games, :description, @game))
        end

        def find_performance!
          dataset = Models::Performance.select(:id)
          performance = with_performance_filter(dataset).first
          return performance if performance
          raise Errors::NoPerformance, @performance
        end

        def with_performance_filter(dataset)
          dataset.where(filter(:performances, :description, @performance))
        end
      end
    end
  end
end
