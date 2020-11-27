require 'active_support/core_ext/object/blank'

class Product
  attr_accessor :id, :name, :value, :brand, :description, :quantity, :errors

  @@products = []
  @@id_auto_increment = 0
  ATTR_KEYS = %i[name value brand].freeze

  def initialize(name: nil, value: nil, brand: nil, description: nil, quantity: nil)
    @name = name
    @value = value
    @brand = brand
    @description = description
    @quantity = quantity
    @errors = {}
  end

  def valid?
    return true unless validate_required?([name, value, brand])

    false
  end

  def uniq?; end

  class << self
    def create(name: nil, value: nil, brand: nil, description: nil, quantity: nil)
      product = Product.new(name: name, value: value, brand: brand, description: description, quantity: quantity)
      product.valid?
      product.save?
      product
    end

    def count
      @@products.count
    end

    def all
      @@products
    end

    def find(id)
      @@products.find { |product| product.id == id }
    end
  end

  def save?
    return false if valid?

    if Product.find(id).nil?
      self.id = @@id_auto_increment += 1
      @@products.push(self)
    else
      @@products[id - 1] = self
    end
    true
  end

  def delete
    @@products.delete(self)
  end

  private

  def validate_required?(field)
    return false unless field.any? { |x| x.blank? }

    field.each_with_index do |x, index|
      index + 1
      @errors.merge!({ ATTR_KEYS[index] => ['can’t be blank'] }) if x.blank?
    end
    true
  end

  def validate_uniq; end
end
