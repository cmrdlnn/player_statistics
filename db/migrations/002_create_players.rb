# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:players) do
      primary_key :id

      column :full_name,  :text
      column :created_at, 'timestamp with time zone'
      column :updated_at, 'timestamp with time zone'
    end
  end
end
