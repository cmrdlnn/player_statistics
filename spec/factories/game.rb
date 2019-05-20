# frozen_string_literal: true

FactoryBot.define do
  factory :game, class: PlayerStatistics::Models::Game do
    description  { Faker::Hipster.sentence }
    line_up_1_id { create(:line_up).id }
    line_up_2_id { create(:line_up).id }
  end
end
