require '.././models/user'
require './shared_examples/valid_spec'

RSpec.describe User do
  after do
    described_class.all.clear
    User.clear_id
  end

  describe 'class methods' do
    describe '#initialize' do
      subject { described_class.new(**attributes) }

      context 'with the correct attributes' do
        let(:attributes) do
          { first_name: 'Sebas', last_name: 'Rodriguez', email: 'seb@gmail.com', age: 18,
            address: 'calle 21' }
        end

        it { is_expected.to be_a(User) }
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
      subject { described_class.create(**attributes) }

      context 'with correct attributes' do
        let(:attributes) do
          { first_name: 'Sebas', last_name: 'Rodriguez', email: 'seb@gmail.com', age: 18,
            address: 'calle 21' }
        end

        let(:user) { described_class.new(**attributes) }

        before do
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

      context 'with two users created' do
        before do
          User.create(first_name: 'Sebas', last_name: 'Rodriguez', email: 'seanrito@gmail.com',
                      age: 18, address: 'calle 21')

          User.create(first_name: 'Shirlez', last_name: 'Dominguez', email: 'shirlez30@gmail.com',
                      age: 42, address: 'calle 67')
        end

        it { is_expected.to eq(2) }
      end

      context 'with no user created yet' do
        it { is_expected.to eq(0) }
      end
    end

    describe '#all' do
      subject { described_class.all }

      context 'it expects to all method return all users saved' do
        before do
          User.create(first_name: 'Sebas', last_name: 'Rodriguez', email: 'seanrito@gmail.com',
                      age: 18, address: 'calle 21')

          User.create(first_name: 'Shirlez', last_name: 'Dominguez', email: 'shirlez30@gmail.com',
                      age: 42, address: 'calle 67')
        end

        it { is_expected.to be_an(Array) }
        it { is_expected.not_to be_empty }
        it { subject.each { |user| expect(user).to be_a(User) } }
      end

      context 'It expects to there aren`t any user' do
        it { is_expected.to be_an(Array)  }
        it { is_expected.to be_empty }
      end
    end

    describe '#find' do
      subject { described_class.find(id) }

      context 'with an existing user' do
        let(:attributes) do
          { first_name: 'Sebas', last_name: 'Rodriguez', email: 'seb@gmail.com', age: 18,
            address: 'calle 21' }
        end

        let(:user) { described_class.create(**attributes) }

        before do
          user
        end

        let(:id) { 1 }

        it { is_expected.to be_a(User) }
        it { is_expected.to have_attributes(attributes) }
      end

      context 'with an non-existent user' do
        let(:id) { 2 }

        it { is_expected.to be_nil }
      end
    end
  end

  describe 'instance methods' do
    describe '#save' do
      subject(:user) { described_class.new(**attributes).save }

      context 'with valid values to save and return true' do
        let(:attributes) do
          { first_name: 'Sebas', last_name: 'Rodriguez', email: 'seanrito@gmail.com', age: 18,
            address: 'calle 21' }
        end

        it { is_expected.to be_truthy }
        it { expect { subject }.to change(User.all, :empty?).from(true).to(false) }
        it { expect { subject }.to change{ User.count }.by(1) }
      end

      context 'expect not save, return false (email duplicate)' do
        before do
          User.create(first_name: 'Sebas', last_name: 'Rodriguez', email: 'seanrito@gmail.com',
                      age: 18, address: 'calle 21')
        end

        let(:attributes) do
          { first_name: 'Shirlez', last_name: 'Dominguez', email: 'seanrito@gmail.com', age: 32,
            address: 'calle 56' }
        end

        it { is_expected.to be_falsey }
      end
     end

    describe '#delete' do
      subject(:delete) { user.delete }

      context 'with two users created and delete the first one' do
        before do
          User.create(first_name: 'Sebas', last_name: 'Rodriguez', email: 'seanrito@gmail.com',
                      age: 18, address: 'calle 21')

          User.create(first_name: 'Shirlez', last_name: 'Dominguez', email: 'shirlez30@gmail.com',
                      age: 42, address: 'calle 67')
        end

        let(:user) { User.all.find { |user| user.id == 2 } }

        it { is_expected.to be_a(User).and be(user) }
        it { expect { subject }.to change { User.count }.by(-1) }
      end

      context 'try to delete a user that not exist' do
        before do
          User.create(first_name: 'Sebas', last_name: 'Rodriguez', email: 'seanrito@gmail.com',
                      age: 18, address: 'calle 21')
        end

        let(:user) { User.all.find { |user| user.id == 2 } }

        it { expect { subject }.to raise_error(StandardError) }
      end
    end

    describe '#update' do
      subject(:update) { user.update }

      context 'with valid values to update and return true' do
        let(:attributes) do
          { first_name: 'Sebas', last_name: 'Rodriguez', email: 'seb@gmail.com', age: 18,
            address: 'calle 21' }
        end

        let(:create) { described_class.create(**attributes) }

        let(:user) { User.find(1) }

        before do
          create
        end

        it 'expect save the address update' do
          user.address = 'Carrera 102'
          expect { subject }.to change { User.find(1).address }
          expect(subject).to be_truthy
        end
      end

      context 'with repeated values, they are not updated and returns false' do
        let(:user) { User.find(1) }

        before do
          User.create(first_name: 'Sebas', last_name: 'Rodriguez', email: 'seanrito@gmail.com',
                      age: 18, address: 'calle 21')

          User.create(first_name: 'Shirlez', last_name: 'Dominguez', email: 'shirlez30@gmail.com',
                      age: 42, address: 'calle 67')
        end

        it 'expect not to save the first name update cause email has been taken' do
          user.first_name = 'Silvia'
          user.email = 'shirlez30@gmail.com'

          expect { subject }.not_to change { User.find(1).first_name }
          expect { subject }.not_to change { User.find(1).email }
          is_expected.to be_falsey
        end
      end
    end

    describe '#valid?' do
      let(:correct_attributes) do
        { first_name: 'Valeria', last_name: 'Hernandez', email: 'val35@gmail.com', age: 18,
          address: 'calle 21'  }
      end

      let(:wrong_attributes) do
        { first_name: 'Valeria', last_name: '', email: 'val35@gmail.com', age: 18,
          address: 'calle 21' }
      end

      let(:object_exist) do
        { first_name: 'Sebas', last_name: 'Rodriguez', email: 'seb@gmail.com', age: 18,
          address: 'calle 21' }
      end

      let(:with_uniq_attributes) do
        { first_name: 'Valeria', last_name: 'Hernandez', email: 'seb@gmail.com', age: 18,
          address: 'calle 21' }
      end

      before do
        User.create(first_name: 'Sebas', last_name: 'Rodriguez', email: 'seb@gmail.com', age: 18,
                    address: 'calle 21')
      end

      it_behaves_like 'HasValidation'
    end
  end
end
