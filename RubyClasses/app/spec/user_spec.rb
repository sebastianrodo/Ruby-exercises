require '.././models/user'
require './shared_examples/base_spec'

RSpec.describe User do
  after do
    described_class.all.clear
    User.clear_id
  end

  let(:correct_attributes) do
    { first_name: 'Sebas', last_name: 'Rodriguez', email: 'seb@gmail.com', age: 18,
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

  let(:with_blank_attributes) do
    { first_name: 'Valeria', last_name: '', email: 'val35@gmail.com', age: 18,
      address: 'calle 21' }
  end

  let(:object_exist) do
    { first_name: 'Sebas', last_name: 'Rodriguez', email: 'seb@gmail.com', age: 18,
      address: 'calle 21' }
  end

  let(:changes) { object.address = 'Carrera 102' }

  let(:repeted_changes) {
    object.first_name = 'Silvia'
    object.email = 'shirlez30@gmail.com'
  }
  #The following variable is about the object have not to any update because the email is repeated
  let(:current_object) { described_class.find(1).first_name && described_class.find(1).email  }

  let(:changes_with_blank) {
    object.first_name = ''
   }
   #The following variable is about the object have not to any update because the first_name is blank
   let(:current_object_without_changes) { described_class.find(1).first_name }

  it_behaves_like 'BaseModelSpec'
end
