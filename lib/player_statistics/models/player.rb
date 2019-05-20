# frozen_string_literal: true

module PlayerStatistics
  module Models
    class Player < Sequel::Model
      many_to_many :line_ups,
                   adder: proc { |line_up|
                     Sequel::Model
                       .db[:line_ups_players]
                       .insert(%i[player_id line_up_id], [id, line_up.id])
                   },
                   dataset: proc {
                     LineUp.select_all(:line_ups)
                           .join(:line_ups_players, line_up_id: :id)
                           .where(player_id: id)
                   }

      many_to_many :games,
                   dataset: proc {
                     Game.select_all(:games)
                         .join(
                           :line_ups,
                           Sequel.|(
                             { Sequel[:line_ups][:id] => :line_up_1_id },
                             { Sequel[:line_ups][:id] => :line_up_2_id }
                           )
                         )
                         .join(:line_ups_players, player_id: :id)
                         .where(player_id: id)
                   }

      many_to_many :teams,
                   dataset: proc {
                     Team.select_all(:teams)
                         .join(:line_ups, team_id: :id)
                         .join(:line_ups_players, line_up_id: :id)
                         .where(player_id: id)
                   }

      many_to_many :performances,
                   dataset: proc {
                     Performance
                       .select_all(:performance)
                       .join(
                         :line_ups_players_performances,
                         performance_id: :id
                       )
                       .where(player_id: id)
                   }
    end
  end
end
