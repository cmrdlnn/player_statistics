# frozen_string_literal: true

FactoryBot.define do
  factory :line_up, class: PlayerStatistics::Models::LineUp do
    team

    trait :with_players do
      transient do
        count { 15 }
      end

      after(:create) do |line_up, evaluator|
        create_list(:player, evaluator.count).each do |player|
          line_up.add_player(player)
        end
      end
    end

    trait :with_game do
      after(:create) do |line_up|
        create(:game, line_up_1_id: line_up.id)
      end
    end
  end
end
