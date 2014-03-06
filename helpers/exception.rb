#-*- encoding: utf-8

class UserNotFound < StandardError; end

class InvalidAPIKey < StandardError; end

def not_found_foreign_key(e)
  var = e.message.scan(/FOREIGN KEY \(`\w+/)[0].split("(`")[1]
end

def raise_helper(e, params)
  begin
    raise e, e.message
  rescue ArgumentError => e
    halt 400, e.message
  rescue Sequel::ForeignKeyConstraintViolation => e 
    var = not_found_foreign_key(e)
    value = eval("params[:#{var}]")
    halt 400, "#{var}(#{value}) is not found." #"#{var}(#{eval(params[:var])}) is not found."
  end
end