shared_examples_for 'save_method' do
  subject(:object) { described_class.new(**correct_attributes).save }

  context 'with valid values to save and return true' do
    it { is_expected.to be_truthy }
    it { expect { subject }.to change(described_class.all, :empty?).from(true).to(false) }
    it { expect { subject }.to change { described_class.count }.by(1) }
  end

  context 'expect not save, return false' do
    before do
      described_class.create(**correct_attributes)
    end

    let(:attributes) { with_uniq_attributes }

    it { is_expected.to be_falsey }
  end
end

shared_examples_for 'delete_method' do
  subject(:delete) { object.delete }

  context 'with two objects created and delete the first one' do
    before do
      described_class.create(**correct_attributes)
      described_class.create(**second_object)
    end

    let(:object) { described_class.all.find { |object| object.id == 2 } }

    it { is_expected.to be_a(described_class).and be(object) }
    it { expect { subject }.to change { described_class.count }.by(-1) }
  end

  context 'try to delete a object that not exist' do
    before do
      described_class.create(**correct_attributes)
    end

    let(:object) { described_class.all.find { |object| object.id == 2 } }

    it { expect { subject }.to raise_error(StandardError) }
  end
end
