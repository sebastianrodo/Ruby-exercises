require '.././models/user'
require './shared_examples/valid_spec'
require './shared_examples/class_methods_spec'
require './shared_examples/instance_methods_spec'

RSpec.describe User do
  after do
    described_class.all.clear
    User.clear_id
  end

  let(:correct_attributes) do
    { first_name: 'Sebas', last_name: 'Rodriguez', email: 'sebas@gmail.com', age: 18,
      address: 'calle 21' }
  end

  let(:wrong_attributes) do
    { first_name: 'Sebas', email: 'seb@gmail.com', age: 18,
      address: 'calle 21', fak_attr: 2 }
  end

  let(:second_object) do
    { first_name: 'Shirlez', last_name: 'Dominguez', email: 'shirlez30@gmail.com',
      age: 42, address: 'calle 67' }
  end

  let(:with_uniq_attributes) do
    { first_name: 'Valeria', last_name: 'Hernandez', email: 'seb@gmail.com', age: 18,
      address: 'calle 21' }
  end

  describe 'class methods' do
    describe '#initialize' do
      it_behaves_like 'initialize_method'
    end

    describe '#create' do
      it_behaves_like 'create_method'
    end

    describe '#count' do
      it_behaves_like 'count_method'
    end

    describe '#all' do
      it_behaves_like 'all_method'
    end

    describe '#find' do
      it_behaves_like 'find_method'
    end
  end

  describe 'instance methods' do
    describe '#save' do
      it_behaves_like 'save_method'
    end

    describe '#delete' do
      it_behaves_like 'delete_method'
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
      let(:wrong_attributes) do
        { first_name: 'Valeria', last_name: '', email: 'val35@gmail.com', age: 18,
          address: 'calle 21' }
      end

      let(:object_exist) do
        { first_name: 'Sebas', last_name: 'Rodriguez', email: 'seb@gmail.com', age: 18,
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
