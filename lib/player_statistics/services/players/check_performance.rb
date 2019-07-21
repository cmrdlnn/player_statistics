# frozen_string_literal: true

module PlayerStatistics
  module Services
    module Players
      class CheckPerformance
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
          dataset.where(Sequel[:players][:id] => @player)
                 .where(Sequel[:games][:id] => @game)
                 .where(Sequel[:performances][:id] => @performance)
        end
      end
    end
  end
end
