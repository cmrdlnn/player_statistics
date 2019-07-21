# frozen_string_literal: true

RSpec.describe PlayerStatistics::Services::Players::FullfillPerformance do
  context 'call' do
    subject { described_class.call(player_arg, game_arg, performance_arg) }

    let(:line_up) { create(:line_up, :with_players, count: 1) }

    let(:player) { line_up.players.first }
    let(:player_id) { player.id }
    let(:player_arg) { player_id }

    let(:game) { create(:game, line_up_1_id: line_up.id) }
    let(:game_arg) { game.id }

    let(:performance) { create(:performance) }
    let(:performance_id) { performance.id }
    let(:performance_arg) { performance_id }

    it do
      subject
      expect(player.performances).to eq([performance])
    end

    describe 'when the specified game doesn\'t exist' do
      let(:game_arg) { -1 }

      it do
        expect { subject }
          .to raise_error(described_class::Errors::PlayerGameMissing)
      end
    end

    describe 'when the specified player doesn\'t exist' do
      let(:player_arg) { -1 }

      it do
        expect { subject }
          .to raise_error(described_class::Errors::PlayerGameMissing)
      end
    end

    describe 'when the performance doesn\'t exist' do
      let(:performance_arg) { -1 }

      it do
        expect { subject }
          .to raise_error(described_class::Errors::NoPerformance)
      end
    end

    describe 'when the performance already fullfilled for specified player ' \
             'and game' do
      before { described_class.call(player_arg, game_arg, performance_arg) }

      it do
        expect { subject }
          .to raise_error(described_class::Errors::AlreadyFullfilled)
      end
    end
  end
end
