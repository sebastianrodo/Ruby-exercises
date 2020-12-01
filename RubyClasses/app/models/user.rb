require 'pry'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/enumerable'

class User
  attr_accessor :id, :first_name, :last_name, :email, :age, :address, :errors
  @@users = []
  @@id_auto_increment = 0
  REQUIRED_KEYS = [:first_name, :last_name, :email]
  UNIQ_KEYS = [:email]

  def initialize(first_name: nil, last_name: nil, email: nil, age: nil, address: nil)
    @first_name = first_name
    @last_name = last_name
    @email = email
    @age = age
    @address = address
    @errors = {}
  end

  class << self
    def create(first_name: nil, last_name: nil, email: nil, age: nil, address: nil)
      user = User.new(first_name: first_name, last_name: last_name, email: email, age: age, address: address)
      user.save
      user
    end

    def count
      @@users.count
    end

    def all
      @@users
    end

    def find(id)
      @@users.find { |user| user.id == id }.clone
    end

    def clear_id
      @@id_auto_increment = 0
    end
  end

  def save
    return false if User.find(id)

    return false unless valid?

    self.id = @@id_auto_increment += 1
    @@users << self.clone

    true
  end

  def update
    return false unless User.find(id)

    return false unless valid?

    @@users[id - 1] = self

    true
  end

  def valid?
    required_condition = valid_required_keys?
    uniq_condition = valid_uniq_keys?

    required_condition && uniq_condition
  end

  def delete
    @@users.delete(self)
  end

  private

  def valid_required_keys?
    REQUIRED_KEYS.map { |key| validate_required?(key) }.exclude?(false)
  end

  def valid_uniq_keys?
    UNIQ_KEYS.map { |key| validate_uniq?(key) }.exclude?(false)
  end

  def validate_required?(field)
    valid_with_condition?(send(field).blank?, field, 'Can’t be blank')
  end

  def validate_uniq?(field)
    if User.find(id)
     return true unless valid_with_condition?(@@users.any? do |user|
      user.send(field) == send(field) && user.send(field) != self.email
     end, field, 'has already been taken')

     false
    end
    if @errors[field].nil?
      valid_with_condition?(@@users.any? { |user| user.send(field) == send(field) }, field, 'has already been taken')
    end
  end

  def valid_with_condition?(condition, field, message)
    if condition
      self.errors = self.errors.merge({ field => [message] })
      false
    else
      self.errors.delete(field)
      true
    end
  end
end
