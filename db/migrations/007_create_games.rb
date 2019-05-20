# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:games) do
      primary_key :id

      column :description, :text
      column :created_at,  'timestamp with time zone'
      column :updated_at,  'timestamp with time zone'

      foreign_key :line_up_1_id, :line_ups,
                  type:      :integer,
                  null:      false,
                  index:     true,
                  on_update: :cascade,
                  on_delete: :cascade

      foreign_key :line_up_2_id, :line_ups,
                  type:      :integer,
                  null:      false,
                  index:     true,
                  on_update: :cascade,
                  on_delete: :cascade

      index :description,
            name:    :games_description_trgm_index,
            type:    :gin,
            opclass: :gin_trgm_ops

      constraint :games_line_ups_inequality,
                 Sequel.~(line_up_1_id: :line_up_2_id)
    end
  end
end
