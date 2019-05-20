# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:line_ups_players) do
      primary_key %i[line_up_id player_id]

      column :created_at, 'timestamp with time zone'
      column :updated_at, 'timestamp with time zone'

      foreign_key :line_up_id, :line_ups,
                  type:      :integer,
                  null:      false,
                  index:     true,
                  on_update: :cascade,
                  on_delete: :cascade

      foreign_key :player_id, :players,
                  type:      :integer,
                  null:      false,
                  index:     true,
                  on_update: :cascade,
                  on_delete: :cascade
    end
  end
end
