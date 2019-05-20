# frozen_string_literal: true

module PlayerStatistics
  module Models
    class Team < Sequel::Model
      one_to_many :line_ups

      many_to_many :players,
                   order: [
                     Sequel[:players][:id],
                     Sequel[:line_ups_players][:created_at]
                   ],
                   dataset: proc {
                     Player.select_all(:players)
                           .distinct(:id)
                           .join(:line_ups_players, player_id: :id)
                           .join(:line_ups, id: :line_up_id)
                           .where(team_id: id)
                   }

      many_to_many :games,
                   order: Sequel[:games][:created_at],
                   dataset: proc {
                     Game.select_all(:games)
                         .join(
                           :line_ups,
                           Sequel.|(
                             { Sequel[:line_ups][:id] => :line_up_1_id },
                             { Sequel[:line_ups][:id] => :line_up_2_id }
                           )
                         )
                         .where(team_id: id)
                   }
    end
  end
end
