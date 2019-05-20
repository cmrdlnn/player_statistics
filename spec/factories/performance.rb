# frozen_string_literal: true

FactoryBot.define do
  factory :performance, class: PlayerStatistics::Models::Performance do
    description { Faker::Hipster.sentence }
  end
end
