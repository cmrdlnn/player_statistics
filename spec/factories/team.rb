# frozen_string_literal: true

FactoryBot.define do
  factory :team, class: PlayerStatistics::Models::Team do
    name { Faker::Team.name }
  end
end
