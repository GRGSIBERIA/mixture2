module Controller
  class User
    include Crypt

    def self.create(params)
      User.add(params)
    end
  end
end