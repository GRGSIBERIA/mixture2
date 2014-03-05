#-*- encoding: utf-8

class UserNotFound < StandardError; end

class InvalidAPIKey < StandardError; end

def extract_foreign_key(e)
  e.message.scan(/FOREIGN KEY \(`\w+/)[0].split("(`")[1]
end