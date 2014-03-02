#-*- encoding: utf-8

class UserNotFound < StandardError; end

class InvalidAPIKey < StandardError; end


def save_to_validate(instance)
  instance.validate
  unless instance.valid? then
    raise ArgumentError, instance.errors.join('\n')
  end
  instance.save
end