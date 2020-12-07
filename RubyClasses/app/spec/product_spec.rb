require '.././models/product'
require './shared_examples/valid_spec'

RSpec.describe Product do
  after do
    described_class.all.clear
    Product.clear_id
  end

  describe 'class methods' do
    describe '#initialize' do
      subject { described_class.new(**attributes) }

      context 'with the correct attributes' do
        let(:attributes) do
          { name: 'TV', value: 1200000, brand: 'LG', description: '32 PL', quantity: 7 }
        end

        it { is_expected.to be_a(Product) }
        it { is_expected.to have_attributes(attributes) }
      end

      context 'with the wrong attributes' do
        let(:attributes) do
          { name: 'TV', value: 1200000, brand: 'LG', fake_attr: 99, description: '32 PL', quantity: 7 }
        end

        it { expect {subject}.to raise_error(ArgumentError) }
      end
    end

    describe '#create' do
      subject { described_class.create(**attributes) }

      context 'with correct attributes' do
        let(:attributes) do
          { name: 'TV', value: 1200000, brand: 'LG', description: '32 PL', quantity: 7 }
        end

        let(:product) { described_class.new(**attributes) }

        before do
          expect(Product).to receive(:new).with(attributes).and_return(product)
          expect(product).to receive(:save).and_call_original
        end

        it { subject }
        it { is_expected.to be_a(Product) }
        it { is_expected.to have_attributes(attributes) }
      end
    end

    describe '#count' do
      subject { described_class.count }

      context 'with two products ' do
        before do
          Product.create(name: 'TV', value: 1200000, brand: 'LG', description: '32 PL', quantity: 7 )
          Product.create(name: 'CELLPHONE', value: 500000, brand: 'XIAOMI', description: '32GB',
                        quantity: 10 )
        end

        it { is_expected.to eq(2) }
      end

      context 'with no pruduct created yet' do
        it { is_expected.to eq(0) }
      end
    end

    describe '#all' do
      subject { described_class.all }

      context 'expect to all method return all products saved' do
        before do
          Product.create(name: 'TV', value: 1200000, brand: 'LG', description: '32 PL', quantity: 7 )
          Product.create(name: 'CELLPHONE', value: 500000, brand: 'XIAOMI', description: '32GB',
                        quantity: 10 )
        end

        it { is_expected.to be_an(Array) }
        it { is_expected.not_to be_empty}
        it { subject.each { |product| expect(product).to be_a(Product) } }
      end
    end

    describe '#find' do
      subject { described_class.find(id) }

      context 'with an existing product' do
        let(:attributes) do
          { name: 'TV', value: 1200000, brand: 'LG', description: '32 PL', quantity: 7 }
        end

        let(:product) { described_class.create(**attributes) }

        before do
          product
        end

        let(:id) { 1 }

        it { is_expected.to be_a(Product) }
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
      subject(:product) { described_class.new(**attributes).save }

      context 'with valid values to save and return true' do
        let(:attributes) do
          { name: 'TV', value: 1200000, brand: 'LG', description: '32 PL', quantity: 7 }
        end

        it { is_expected.to be_truthy }
        it { expect { subject }.to change(Product.all, :empty?).from(true).to(false) }
        it { expect { subject }.to change{ Product.count }.by(1) }
      end

      context 'expect not save, return false (missing valur)' do
        let(:attributes) do
          { name: 'TV', brand: 'LG', description: '32 PL', quantity: 7 }
        end

        it { is_expected.to be_falsey }
      end
    end

    describe '#delete' do
      subject(:delete) { product.delete }

      context 'with two products created and delete the first one' do
        before do
          Product.create(name: 'TV', value: 1200000, brand: 'LG', description: '32 PL', quantity: 7 )

          Product.create(name: 'CELLPHONE', value: 500000, brand: 'XIAOMI', description: '32GB',
                        quantity: 10 )
        end

        let(:product) { Product.all.find { |product| product.id == 2 } }

        it { expect(subject).to be_a(Product).and be(product) }
        it { expect { subject }.to change { Product.count }.by(-1) }
      end

      context 'try to delete a product that not exist' do
        before do
          Product.create(name: 'TV', value: 1200000, brand: 'LG', description: '32 PL', quantity: 7 )
        end

        let(:product) { Product.all.find { |product| product.id == 2 } }

        it { expect { subject }.to raise_error(StandardError) }
      end
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
