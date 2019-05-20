# frozen_string_literal: true

RSpec.describe PlayerStatistics::Models::Game do
  context '.create' do
    subject { described_class.create(params) }

    let(:params) { { line_up_1_id: line_up_1_id, line_up_2_id: line_up_2_id } }
    let(:line_up_1_id) { create(:line_up).id }
    let(:line_up_2_id) { create(:line_up).id }

    describe 'result' do
      it { is_expected.to be_a(described_class) }
    end

    describe 'when `line_up_1_id` is not specified' do
      let(:params) { { line_up_2_id: line_up_2_id } }

      it do
        expect { subject }.to raise_error(Sequel::NotNullConstraintViolation)
      end
    end

    describe 'when `line_up_1_id` is nil' do
      let(:line_up_1_id) { nil }

      it do
        expect { subject }.to raise_error(Sequel::InvalidValue)
      end
    end

    describe 'when `line_up_1_id` refers to line_up that doesn\'t exist' do
      let(:line_up_1_id) { 2_147_483_647 }

      it do
        expect { subject }.to raise_error(Sequel::ForeignKeyConstraintViolation)
      end
    end

    describe 'when `line_up_2_id` is not specified' do
      let(:params) { { line_up_1_id: line_up_1_id } }

      it do
        expect { subject }.to raise_error(Sequel::NotNullConstraintViolation)
      end
    end

    describe 'when `line_up_2_id` is nil' do
      let(:line_up_2_id) { nil }

      it do
        expect { subject }.to raise_error(Sequel::InvalidValue)
      end
    end

    describe 'when `line_up_2_id` refers to `line_up` that doesn\'t exist' do
      let(:line_up_2_id) { 2_147_483_647 }

      it do
        expect { subject }.to raise_error(Sequel::ForeignKeyConstraintViolation)
      end
    end

    describe 'when `line_up_1_id` and `line_up_2_id` is equal' do
      let(:line_up_2_id) { line_up_1_id }

      it do
        expect { subject }.to raise_error(Sequel::CheckConstraintViolation)
      end
    end
  end

  context '`teams` association' do
    subject { game.teams }

    let(:line_up1) { create(:line_up) }
    let(:line_up2) { create(:line_up) }
    let(:game) do
      create(:game, line_up_1_id: line_up1.id, line_up_2_id: line_up2.id)
    end

    let(:teams) { [line_up1, line_up2].map(&:team) }

    it { expect(subject).to eq(teams) }
  end

  context '`players` association' do
    subject { game.players }

    let(:line_up1) { create(:line_up, :with_players, count: 1) }
    let(:line_up2) { create(:line_up, :with_players, count: 1) }
    let(:game) do
      create(:game, line_up_1_id: line_up1.id, line_up_2_id: line_up2.id)
    end

    let(:players) { [line_up1, line_up2].map(&:players).flatten }

    it { expect(subject).to eq(players) }
  end
end
