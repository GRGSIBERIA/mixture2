module Model
  def countup(dbname, argument)
    case argument
    when Integer
      DB[dbname].where(id: argument).update(Sequel.+(:count, 1))
    when String
      DB[dbname].where(name: argument).update(Sequel.+(:count, 1))
    end
  end

  def countdown(dbname, argument)
    case argument
    when Integer
      DB[dbname].where(id: argument).update(Sequel.-(:count, 1))
    when String
      DB[dbname].where(name: argument).update(Sequel.-(:count, 1))
    end
  end

  def find(dbname, argument)
    inst = nil
    case argument
    when Integer
      inst = DB[dbname].where(id: argument).first
    when String
      if argument =~ /\A\d+\z/ then
        inst = DB[dbname].where(id: argument.to_i).first
      else
        inst = DB[dbname].where(name: argument).first
      end
    end
    if inst.nil? then
      raise ArgumentError, "#{inst} is not found from #{dbname.to_s}."
    end
    inst
  end

  module_function :countup
  module_function :countdown
  module_function :find
end