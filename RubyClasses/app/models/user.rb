require 'pry'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/enumerable'
require_relative './Base'
#require_relative './concerns/has_validation'

class User < Base
  #include ::HasValidation
  attr_accessor :id, :first_name, :last_name, :email, :age, :address, :errors

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
  end
end
