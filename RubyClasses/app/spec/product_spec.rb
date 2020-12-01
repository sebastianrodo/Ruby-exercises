# frozen_string_literal: true

require '.././models/product'

RSpec.describe 'Product' do
  before do
    @product = Product.new(12_345, 'Computer', 1_200_000, 's', '14 Inches, 16GB RAM, I5 10TH GEN', 2)
  end

  context 'Validate values', important: true do
    it 'Validate if required values are filled' do
      expect(@product.id).to be.positive?
      expect(@product.name).not_to be_empty
      expect(@product.value).to be.positive?
      expect(@product.brand).not_to be_empty
    end

    it 'Should validate if id, value and quantity are Numeric' do
      expect(@product.id).to be_kind_of Numeric
      expect(@product.value).to be_kind_of Numeric
      expect(@product.quantity).to be_kind_of Numeric
    end
  end

  context 'Get product specs', important: true do
    it 'Should tell the product id' do
      expect(@product.id).to eq(12_345)
    end

    it 'Should tell the product name' do
      expect(@product.name).to eq('Computer')
    end

    it 'Should tell the product value' do
      expect(@product.value).to eq(1_200_000)
    end

    it 'Sould tell the product brand' do
      expect(@product.brand).to eq('s')
    end

    it 'Should tell the product description' do
      expect(@product.description).to eq('14 Inches, 16GB RAM, I5 10TH GEN')
    end

    it 'Should tell the product quantity' do
      expect(@product.quantity).to eq(2)
    end
  end
end



        # it { expect(subject.first_name).to eq('Sebas') }
        # it { expect(subject.last_name).to eq('Rodriguez') }
        # it { expect(subject.email).to eq('seb@gmail.com') }
        # it { expect(subject.age).to eq(18) }
        # it { expect(subject.address).to eq('calle 21') }



        #expect(User).to receive(:new).with(attributes).and_call_original
        #expect_any_instance_of(User).to receive(:save).and_call_original



        # def save
        #   return false unless valid?

        #   if User.find(id)
        #     @@users[id - 1] = self
        #   else
        #     self.id = @@id_auto_increment += 1
        #     @@users << self.clone
        #   end

        #   true
        # end