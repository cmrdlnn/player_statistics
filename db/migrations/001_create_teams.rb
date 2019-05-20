# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:teams) do
      primary_key :id

      column :name,       :text
      column :created_at, 'timestamp with time zone'
      column :updated_at, 'timestamp with time zone'

      index :name,
            name:    :teams_name_trgm_index,
            type:    :gin,
            opclass: :gin_trgm_ops
    end
  end
end
