require 'pry'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/enumerable'
#require_relative './concerns/has_validation'
require_relative './base_model'

class Product < BaseModel
  #include ::HasValidation
  attr_accessor :id, :name, :value, :brand, :description, :quantity, :errors

  REQUIRED_KEYS = [:name, :value, :brand]
  UNIQ_KEYS = [:name]

  def initialize(name: nil, value: nil, brand: nil, description: nil, quantity: nil)
    super()
    @name = name
    @value = value
    @brand = brand
    @description = description
    @quantity = quantity
  end

  class << self
    def create(name: nil, value: nil, brand: nil, description: nil, quantity: nil)
      product = Product.new(name: name, value: value, brand: brand, description: description, quantity: quantity)
      product.save
      product
    end
  end
end
