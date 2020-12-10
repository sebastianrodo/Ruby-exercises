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

  let(:with_blank_attributes) do
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

  it_behaves_like 'ClassMethods'

  it_behaves_like 'InstanceMethods'

  describe 'instance methods' do
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
      before do
        Product.create(name: 'CELLPHONE', value: 500000, brand: 'XIAOMI', description: '32GB',
          quantity: 10 )
      end

      it_behaves_like 'HasValidation'
    end
  end
end
