module Model
  def save_to_validate(instance)
    instance.validate
    unless instance.valid? then
      raise ArgumentError, instance.errors.full_messages.join('<br>')
    end
    instance.save
  end

  def exists(type, column, value)
    inst = type.find({column => value})
    if inst.nil? then
      raise ArgumentError, "#{type.to_s} #{column.to_s}(value) is not found.<br>"
    end
  end

  module_function :exists
  module_function :save_to_validate
end