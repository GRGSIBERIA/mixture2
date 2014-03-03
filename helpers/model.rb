module Model
  def save_to_validate(instance)
    instance.validate
    unless instance.valid? then
      raise ArgumentError, instance.errors.full_messages.join('<br>')
    end
    instance.save
  end

  module_function :save_to_validate
end