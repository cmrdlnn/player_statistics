# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:line_ups_players_performances) do
      primary_key %i[line_up_id player_id performance_id]

      column :line_up_id, :integer, index: true
      column :player_id,  :integer, index: true
      column :created_at, 'timestamp with time zone'
      column :updated_at, 'timestamp with time zone'

      foreign_key %i[line_up_id player_id], :line_ups_players,
                  null:      false,
                  index:     true,
                  on_update: :cascade,
                  on_delete: :cascade

      foreign_key :performance_id, :performances,
                  type:      :integer,
                  null:      false,
                  index:     true,
                  on_update: :cascade,
                  on_delete: :cascade
    end
  end
end
