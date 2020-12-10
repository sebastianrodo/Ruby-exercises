class BaseModel
  @@resources = []
  @@id_auto_increment = 0

  def initialize
    @errors = {}
  end

  class << self
    def count
      @@resources.count
    end

    def all
      @@resources
    end

    def find(id)
      @@resources.find { |resource| resource.id == id }.clone
    end

    def clear_id
      @@id_auto_increment = 0
    end
  end

  def save
    return false unless valid?

    if self.class.find(id)
      @@resources[id - 1] = self
    else
      self.id = @@id_auto_increment += 1
      @@resources << self
    end

    true
  end

  def delete
    @@resources.delete(self)
  end

  def update
    return true if save

    false
  end

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
    find_exist_resource = self.class.find(id)
    condition = self.class.all.any? { |resource| resource.send(field) == send(field) }

    if find_exist_resource
      return true if send(field) == find_exist_resource.send(field)

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