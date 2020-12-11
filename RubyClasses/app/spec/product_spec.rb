require '.././models/product'
require './shared_examples/base_spec'

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
    { name: 'TV', value: 1200000, brand: 'LG', description: '32 PL', quantity: 7 }
  end

  let(:with_uniq_attributes) do
    { name: 'TV', value: 30000, brand: 'ZOOM', description: 'MP3 LIGHT',
      quantity: 90}
  end

  let(:changes) { object.value = 900000 }

  let(:repeted_changes) {
    object.brand = 'MAC'
    object.name = 'CELLPHONE'
  }
  #The following variable is about the object have not to any update because the name is repeated
  let(:current_object) { described_class.find(1).brand && described_class.find(1).name  }

  let(:changes_with_blank) {
    object.value = ''
   }
   #The following variable is about the object have not to any update because the balue is blank
   let(:current_object_without_changes) { described_class.find(1).value }

  it_behaves_like 'BaseModelSpec'
end
