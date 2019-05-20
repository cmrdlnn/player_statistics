# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:performances) do
      primary_key :id

      column :description, :text
      column :created_at,  'timestamp with time zone'
      column :updated_at,  'timestamp with time zone'

      index :description,
            name:    :performances_description_trgm_index,
            type:    :gin,
            opclass: :gin_trgm_ops
    end
  end
end
