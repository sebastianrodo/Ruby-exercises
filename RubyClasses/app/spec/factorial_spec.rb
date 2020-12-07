require '.././models/factorial'

RSpec.describe Factorial do
  describe '#calculate_factorial' do
    subject { described_class.calculate_factorial(**attribute) }

    context 'with the correct result' do
      let(:attribute) { { number: 7 } }

      it { is_expected.to eq(5040) }
    end

    context 'when number is 0 the result have to be 1' do
      let(:attribute) { { number: 0 } }

      it { is_expected.to eq(1) }
    end
  end
end
