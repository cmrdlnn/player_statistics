# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:line_ups) do
      primary_key :id

      column :created_at, 'timestamp with time zone'
      column :updated_at, 'timestamp with time zone'

      foreign_key :team_id, :teams,
                  type:      :integer,
                  null:      false,
                  index:     true,
                  on_update: :cascade,
                  on_delete: :cascade
    end
  end
end
