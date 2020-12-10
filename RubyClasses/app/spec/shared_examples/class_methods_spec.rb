shared_examples_for 'ClassMethods' do
  describe 'class methods' do
    describe '#initialize' do
      subject { described_class.new(**attributes) }

      context 'with the correct attributes' do
        let(:attributes) { correct_attributes }

        it { is_expected.to be_a(described_class) }
        it { is_expected.to have_attributes(attributes) }
      end

      context 'with the wrong attributes' do
        let(:attributes) { wrong_attributes }

        it { expect { subject }.to raise_error(ArgumentError) }
      end
    end

    describe '#create' do
      subject { described_class.create(**attributes) }

      context 'with correct attributes' do
        let(:attributes) { correct_attributes }
        let(:object) { described_class.new(**attributes) }

        before do
          expect(described_class).to receive(:new).with(attributes).and_return(object)
          expect(object).to receive(:save).and_call_original
        end

        it { subject }
        it { is_expected.to be_a(described_class) }
        it { is_expected.to have_attributes(attributes) }
      end
    end

    describe '#count' do
      subject { described_class.count }

      context 'with two object created' do
        before do
          described_class.create(**correct_attributes)
          described_class.create(**second_object)
        end

        it { is_expected.to eq(2) }
      end

      context 'with no object created yet' do
        it { is_expected.to eq(0) }
      end
    end

    describe '#find' do
      subject { described_class.find(id) }

      context 'with an existing object' do
        let(:object) { described_class.create(**correct_attributes) }

        before do
          object
        end

        let(:id) { 1 }

        it { is_expected.to be_a(described_class) }
        it { is_expected.to have_attributes(correct_attributes) }
      end

      context 'with an non-existent object' do
        let(:id) { 2 }

        it { is_expected.to be_nil }
      end
    end
  end
end
