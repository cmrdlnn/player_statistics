# frozen_string_literal: true

module PlayerStatistics
  module Models
    class Game < Sequel::Model
      many_to_many :line_ups,
                   dataset: proc {
                     LineUp.select_all(:line_ups)
                           .where(Sequel[:line_ups][:id] => [line_up_1_id,
                                                             line_up_2_id])
                   }

      many_to_many :teams,
                   dataset: proc {
                     Team.select_all(:teams)
                         .join(:line_ups, team_id: :id)
                         .where(Sequel[:line_ups][:id] => [line_up_1_id,
                                                           line_up_2_id])
                   }

      many_to_many :players,
                   dataset: proc {
                     Player.select_all(:players)
                           .join(:line_ups_players, player_id: :id)
                           .join(:line_ups, id: :line_up_id)
                           .where(Sequel[:line_ups][:id] => [line_up_1_id,
                                                             line_up_2_id])
                   }

      many_to_many :performances,
                   dataset: proc {
                     Performance.select_all(:performances)
                                .join(
                                  :line_ups_players_performances,
                                  performance_id: :id
                                )
                                .join(:line_ups, id: :line_up_id)
                                .where(
                                  Sequel.|(
                                    { Sequel[:line_ups][:id] => line_up_1_id },
                                    { Sequel[:line_ups][:id] => line_up_2_id }
                                  )
                                )
                   }
    end
  end
end
