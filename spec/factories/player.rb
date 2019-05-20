# frozen_string_literal: true

FactoryBot.define do
  factory :player, class: PlayerStatistics::Models::Player do
    full_name { Faker::Name.name }
  end
end
