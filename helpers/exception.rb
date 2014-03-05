#-*- encoding: utf-8

class UserNotFound < StandardError; end

class InvalidAPIKey < StandardError; end

def not_found_foreign_key(e)
  var = e.message.scan(/FOREIGN KEY \(`\w+/)[0].split("(`")[1]
end