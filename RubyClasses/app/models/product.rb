require 'pry'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/enumerable'
require_relative './concerns/has_validation'

class Product
  include ::HasValidation

  attr_accessor :id, :name, :value, :brand, :description, :quantity, :errors

  @@products = []
  @@id_auto_increment = 0
  REQUIRED_KEYS = [:name, :value, :brand]
  UNIQ_KEYS = [:name]

  def initialize(name: nil, value: nil, brand: nil, description: nil, quantity: nil)
    @name = name
    @value = value
    @brand = brand
    @description = description
    @quantity = quantity
    @errors = {}
  end

  class << self
    def create(name: nil, value: nil, brand: nil, description: nil, quantity: nil)
      product = Product.new(name: name, value: value, brand: brand, description: description, quantity: quantity)
      product.save
      product
    end

    def count
      @@products.count
    end

    def all
      @@products
    end

    def find(id)
      @@products.find { |product| product.id == id }.clone
    end

    def clear_id
      @@id_auto_increment = 0
    end
  end

  def save
    return false unless valid?

    if Product.find(id)
      @@products[id - 1] = self
    else
      self.id = @@id_auto_increment += 1
      @@products << self
    end

    true
  end

  def update
    return true if save

    false
  end

  def delete
    @@products.delete(self)
  end
end
