module Model
  class User
    def initialize(params)
      @id = DB[:users].count + 1
      
    end
  end
end