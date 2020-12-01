require '.././models/user'

RSpec.describe User do
  describe 'class methods' do
    after do
      described_class.all.clear
      User.clear_id
    end

    describe '#initialize' do
      subject { described_class.new(attributes) }

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
      subject { described_class.create(attributes) }

      context 'with correct atrributes' do
        let(:attributes) do
          { first_name: 'Sebas', last_name: 'Rodriguez', email: 'seb@gmail.com', age: 18,
            address: 'calle 21' }
        end

        let(:user) { described_class.new(attributes) }

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

      context 'with two user created' do
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

      context 'It expects to all method return all users saved' do
        before do
          User.create(first_name: 'Sebas', last_name: 'Rodriguez', email: 'seanrito@gmail.com',
                      age: 18, address: 'calle 21')

          User.create(first_name: 'Shirlez', last_name: 'Dominguez', email: 'shirlez30@gmail.com',
                      age: 42, address: 'calle 67')
        end

        it { expect(subject).to be_an(Array) }
        it { expect(subject).not_to be_empty }
        it { subject.each { |user| expect(user).to be_a(User) } }
      end

      context 'It expects to there aren`t any user' do
        it { is_expected.to be_an(Array)  }
        it { is_expected.to be_empty }
      end
    end

    describe '#find' do
      subject { described_class.find(id) }

      before do
        User.create(first_name: 'Sebas', last_name: 'Rodriguez', email: 'seanrito@gmail.com', age: 18,
                    address: 'calle 21')
      end

      context 'with an existing user' do
        let(:id) { 1 }

        it { is_expected.to be_a(User) }
        it { expect(subject.first_name).to eq('Sebas') }
        it { expect(subject.last_name).to eq('Rodriguez') }
        it { expect(subject.email).to eq('seanrito@gmail.com') }
        it { expect(subject.age).to eq(18) }
        it { expect(subject.address).to eq('calle 21') }
        it { expect(subject.id).to eq(1) }
      end

      context 'with an non-existent user' do
        let(:id) { 2 }

        it { is_expected.to be_nil }
      end
    end
  end

  describe 'instance methods' do
    describe '#save' do
      subject(:user) { described_class.new(attributes) }

      let(:attributes) do
        { first_name: 'Sebas', last_name: 'Rodriguez', email: 'seanrito@gmail.com', age: 18,
          address: 'calle 21' }
      end

      context 'with valid values to save and return true' do
        it { expect(subject.save).to be(true) }
      end

      context 'the user expect to saved correctly' do
        let(:attributes) do
          { first_name: 'Shirlez', last_name: 'Dominguez', email: 'alrov@gmail.com', age: 32,
            address: 'calle 56' }
        end

        it { expect { subject.save }.to change { User.count }.by(1) }
      end

      context 'with invalid values, not save and return false' do
        let(:attributes) do
          { first_name: 'Silvia', last_name: 'Visbal', email: 'seanrito@gmail.com', age: 65,
            address: 'Carrera 18' }
        end

        it { expect(subject.save).to be(false) }
        it 'insert an error message in an object in case that the email has been taken by another user' do
          expect { subject.save }.to change(subject, :errors).from({}).to({ email: ['has already been taken'] })
        end
      end

      context 'with invalid values, not save and insert an error message' do
        let(:attributes) do
          { first_name: 'Susana', email: 'sus@gmail.com', age: 19, address: 'Carrera 38' }
        end

        it 'insert an error message in an object in case that the last name be blank' do
          expect { subject.save }.to change(subject, :errors).from({}).to({ last_name: ['Can’t be blank'] })
        end
      end
    end

    describe '#delete' do
      subject(:delete) { described_class.new.delete }

      before do
        described_class.all.clear
        User.clear_id
      end

      context 'with two user created and delete the first one' do
        before do
          User.create(first_name: 'Sebas', last_name: 'Rodriguez', email: 'seanrito@gmail.com',
                      age: 18, address: 'calle 21')

          User.create(first_name: 'Shirlez', last_name: 'Dominguez', email: 'shirlez30@gmail.com',
                      age: 42, address: 'calle 67')
        end

        let(:user) { User.all.find { |user| user.id == 1 } }

        it { expect(user.delete).to be_a(User).and be(user) }
      end
    end
  end
end
