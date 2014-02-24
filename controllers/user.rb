module Controller
  class User
    include Crypt

    def self.create(params)
      user = User.add(params)
    end
  end
end