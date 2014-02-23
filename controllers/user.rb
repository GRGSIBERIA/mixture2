module Controller
  class User
    include Crypt

    def self.create(params)
      user = User.add(params)
      Validation.is_blank(user, :password, params)
      Validation.is_blank(user, :email, params)
      Validation.in_range(user, :password, params, 4, 140)
      Validation.in_range(user, :email, params, 5, 256)
      user
    end
  end
end