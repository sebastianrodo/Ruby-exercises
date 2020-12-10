shared_examples_for 'HasValidation' do
  subject { object.valid? }

  context 'with correct attributes, object not exist' do
    let(:object) { described_class.new(**correct_attributes) }

    it { is_expected.to be_truthy }
  end

  context 'without an attribute required' do
    let(:object) { described_class.new(**with_blank_attributes) }

    it 'expect insert error message into the object' do
      expect { subject }.to change(object, :errors)
      expect(object.errors).to have_value(['Can’t be blank'])
    end
    it { is_expected.to be_falsey }
  end

  context 'object already exist' do
    let(:object) { described_class.new(**object_exist) }

    it { is_expected.to be_falsey }
  end

  context 'with an attribute uniq repeated' do
    let(:object) { described_class.new(**with_uniq_attributes) }

    it 'expect insert error message into the object' do
      expect { subject }.to change(object, :errors)
      expect(object.errors).to have_value(['has already been taken'])
    end
    it { is_expected.to be_falsey }
  end
end
