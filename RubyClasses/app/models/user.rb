require 'pry'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/enumerable'
require_relative './concerns/has_validation'

class User
  include ::HasValidation

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
    return false unless valid?

    if User.find(id)
      @@users[id - 1] = self
    else
      self.id = @@id_auto_increment += 1
      @@users << self
    end

    true
  end

  def update
    return true if save

    false
  end

  def delete
    @@users.delete(self)
  end
end
