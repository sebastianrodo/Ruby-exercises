shared_examples_for 'BaseModelSpec' do
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

  describe 'class methods' do
    describe '#save' do
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

    describe '#update' do
      subject(:update) { object.update }

      context 'with valid values to update and return true' do
        let(:create) { described_class.create(**correct_attributes) }

        let(:object) { described_class.find(1) }

        before do
          create
        end

        it 'expect save the address update' do
          changes
          expect { subject }.to change { described_class.find(1) }
          expect(subject).to be_truthy
        end
      end

      context 'with repeated values, they are not updated and returns false' do
        let(:object) { described_class.find(1) }

        before do
          described_class.create(**correct_attributes)

          described_class.create(**second_object)
        end


        it 'expect not to save the first name update cause email has been taken' do
          repeted_changes
          expect { subject }.not_to change { current_object }
          is_expected.to be_falsey
        end
      end

      context 'with blank values, they are not updated and return false' do
        let(:object) { described_class.find(1) }

        before do
          described_class.create(**correct_attributes)

          described_class.create(**second_object)
        end

        it 'expect not to save the update cause brand is blank' do
          changes_with_blank
          expect { subject }.not_to change { current_object_without_changes }
          is_expected.to be_falsey
        end
      end
    end

    describe '#delete' do
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

    describe '#valid?' do
      subject { object.valid? }

      let(:create) { described_class.create(**correct_attributes) }
      before do
        create
      end

      context 'with correct attributes, object not exist' do
        let(:object) { described_class.new(**second_object) }

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
  end
end
