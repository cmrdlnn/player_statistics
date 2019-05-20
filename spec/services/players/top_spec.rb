# frozen_string_literal: true

RSpec.describe PlayerStatistics::Services::Players::Top do
  context 'call' do
    subject { described_class.call(performance_arg) }

    let(:performance) { create(:performance) }
    let(:performance_id) { performance.id }
    let(:performance_arg) { performance_id }

    let(:team) { create(:team) }
    let(:players) { create_list(:player, 15) }
    let(:line_ups) { create_list(:line_up, 6, team: team) }

    before do
      performance_rows = []
      rows = players.map.with_index do |player, i|
        line_ups.map.with_index do |line_up, j|
          if i < 6 && j <= i
            performance_rows.push(
              player_id: player.id,
              line_up_id: line_up.id,
              performance_id: performance_id
            )
          end

          { line_up_id: line_up.id, player_id: player.id }
        end
      end

      Sequel::Model.db[:line_ups_players].multi_insert(rows.flatten)
      Sequel::Model.db[:line_ups_players_performances].multi_insert(
        performance_rows
      )
    end

    let(:result) do
      top = players[1..5].map.with_index do |player, i|
        { full_name: player.full_name, performed_times: i + 2 }
      end
      top.reverse
    end

    it { is_expected.to eq(result) }
  end
end
