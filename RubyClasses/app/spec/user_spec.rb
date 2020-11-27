require '.././models/user'
# require './spec_helper'

RSpec.describe User do
  describe 'class methods' do
    describe '#initialize' do
      # subject { User.new(attributes) }
      subject { described_class.new(attributes) }

      context 'with the correct attributes' do
        let(:attributes) do
          { first_name: 'Sebas', last_name: 'Rodriguez', email: 'seb@gmail.com', age: 18,
            address: 'calle 21' }
        end

        it { is_expected.to be_a(User) }
        # it { expect(subject.first_name).to eq('Sebas') }
        # it { expect(subject.last_name).to eq('Rodriguez') }
        # it { expect(subject.email).to eq('seb@gmail.com') }
        # it { expect(subject.age).to eq(18) }
        # it { expect(subject.address).to eq('calle 21') }
        it { is_expected.to have_attributes(attributes) }
      end

      context 'with the wrong attributes' do
        let(:attributes) do
          { first_name: 'Sebas', email: 'seb@gmail.com', age: 18,
            address: 'calle 21', fak_attr: 2 }
        end

        it { expect { subject }.to raise_error(ArgumentError) }
      end
    end

    describe '#create' do
      subject { described_class.create(attributes) }

      context 'with correct atrrtibutes' do
        let(:attributes) do
          { first_name: 'Sebas', last_name: 'Rodriguez', email: 'seb@gmail.com', age: 18,
            address: 'calle 21' }
        end

        let(:user) {described_class.new(attributes)}

        before do
          #expect(User).to receive(:new).with(attributes).and_call_original
          #expect_any_instance_of(User).to receive(:save).and_call_original
          expect(User).to receive(:new).with(attributes).and_return(user)
          expect(user).to receive(:save).and_call_original
        end

        it { subject }
        it { is_expected.to be_a(User) }
        it { is_expected.to have_attributes(attributes) }
      end
    end

    describe '#count' do
      subject { described_class.count }

        it 'It expects to count the correct number of users' do
          expect(subject).to eq(1)
        end
    end

    describe '#all' do
      subject { described_class.all }

        it 'It expects to all method return an array' do
          expect(subject).to be_an(Array)
        end

        it 'It expects to there aren`t any user' do
          expect(subject).not_to be_nil
        end
    end

    describe '#find' do
      subject { described_class.find(id) }
    end
  end

  describe 'instance methods' do
    describe '#save' do


    end
  end
end
