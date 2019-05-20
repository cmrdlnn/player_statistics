# frozen_string_literal: true

module PlayerStatistics
  module Models
    class LineUp < Sequel::Model
      many_to_one  :team

      many_to_many :players,
                   adder: proc { |player|
                     Sequel::Model
                       .db[:line_ups_players]
                       .insert(%i[player_id line_up_id], [player.id, id])
                   },
                   dataset: proc {
                     Player.select_all(:players)
                           .join(:line_ups_players, player_id: :id)
                           .where(line_up_id: id)
                   }

      many_to_many :games,
                   dataset: proc {
                     Game.select_all(:games)
                         .where(
                           Sequel.|({ line_up_1_id: id }, { line_up_2_id: id })
                         )
                   }

      many_to_many :performances,
                   dataset: proc {
                     Performance.select_all(:performances)
                                .join(
                                  :line_ups_players_performances,
                                  performance_id: :id
                                )
                                .where(line_up_id: id)
                   }
    end
  end
end
