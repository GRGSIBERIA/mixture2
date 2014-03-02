module Model
  def countup(dbname, argument)
    case argument
    when Integer
      DB[dbname].where(id: => argument).update(Sequel.+(:count, 1))
    when String
      DB[dbname].where(name: => argument).update(Sequel.+(:count, 1))
    end
  end

  def countdown(dbname, argument)
    case argument
    when Integer
      DB[dbname].where(id: => argument).update(Sequel.-(:count, 1))
    when String
      DB[dbname].where(name: => argument).update(Sequel.-(:count, 1))
    end
  end

  module_function :countup
  module_function :countdown
end