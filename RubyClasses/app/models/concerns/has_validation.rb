require 'active_support/concern'

module HasValidation
  extend ActiveSupport::Concern

  def valid?
    required_condition = valid_required_keys?
    uniq_condition = valid_uniq_keys?

    required_condition && uniq_condition
  end

  private

  def valid_required_keys?
    self.class::REQUIRED_KEYS.map { |key| validate_required?(key) }.exclude?(false)
  end

  def valid_uniq_keys?
    self.class::UNIQ_KEYS.map { |key| validate_uniq?(key) }.exclude?(false)
  end

  def validate_required?(field)
    valid_with_condition?(send(field).blank?, field, 'Can’t be blank')
  end

  def validate_uniq?(field)
    find_exist_object = self.class.find(id)
    condition = self.class.all.any? { |object| object.send(field) == send(field) }

    if find_exist_object
      return true if send(field) == find_exist_object.send(field)

      return false unless valid_with_condition?(condition, field, 'has already been taken')

      true
    else
      validate_uniq_exist_object?(field, condition)
    end
  end

  def validate_uniq_exist_object?(field, condition)
    valid_with_condition?(condition, field, 'has already been taken') if @errors[field].nil?
  end

  def valid_with_condition?(condition, field, message)
    if condition
      self.errors = errors.merge({ field => [message] })
      false
    else
      errors.delete(field)
      true
    end
  end
end
