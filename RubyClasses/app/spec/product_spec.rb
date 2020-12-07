require '.././models/product'
require './shared_examples/valid_spec'
require './shared_examples/class_methods_spec'
require './shared_examples/instance_methods_spec'

RSpec.describe Product do
  after do
    described_class.all.clear
    Product.clear_id
  end

  let(:correct_attributes) do
    { name: 'TV', value: 1200000, brand: 'LG', description: '32 PL', quantity: 7 }
  end

  let(:wrong_attributes) do
    { name: 'CELLPHONE', value: 500000, brand: 'XIAOMI', description: '32GB',
      quantity: 10, fak_attr: 243  }
  end

  let(:second_object) do
    { name: 'CELLPHONE', value: 500000, brand: 'XIAOMI', description: '32GB',
      quantity: 10 }
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
      subject(:update) { product.update }

      context 'with valid values to update and return true' do
        let(:attributes) do
          { name: 'TV', value: 1200000, brand: 'LG', description: '32 PL', quantity: 7 }
        end

        let(:create) { described_class.create(**attributes) }

        let(:product) { Product.find(1) }

        before do
          create
        end

        it 'expect save the value update' do
          product.value = 900000
          expect { subject }.to change { Product.find(1).value }
          is_expected.to be_truthy
        end
      end

      context 'with blank values, they are not updated and return false' do
        let(:product) { Product.find(1) }

        before do
          Product.create(name: 'TV', value: 1200000, brand: 'LG', description: '32 PL', quantity: 7 )

          Product.create(name: 'CELLPHONE', value: 500000, brand: 'XIAOMI', description: '32GB',
                        quantity: 10 )
        end

        it 'expect not to save the update cause brand is blank' do
          product.brand = ''
          expect { subject }.not_to change { Product.find(1).brand }
          is_expected.to be_falsey
        end
      end
    end

    describe '#valid?' do
      let(:correct_attributes) do
        { name: 'TV', value: 8000000, brand: 'LG', description: '42 PL', quantity: 822 }
      end

      let(:wrong_attributes) do
        { name: 'TV', brand: 'LG', description: '42 PL', quantity: 8 }
      end

      let(:object_exist) do
        { name: 'CELLPHONE', value: 500000, brand: 'XIAOMI', description: '32GB',
          quantity: 10}
      end

      let(:with_uniq_attributes) do
        { name: 'CELLPHONE', value: 30000, brand: 'ZOOM', description: 'MP3 LIGHT',
          quantity: 90}
      end

      before do
        Product.create(name: 'CELLPHONE', value: 500000, brand: 'XIAOMI', description: '32GB',
          quantity: 10 )
      end

      it_behaves_like 'HasValidation'
    end
  end
end
