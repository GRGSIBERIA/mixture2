
module Models
  class User < Model::Base
    include Crypt

    def initialize(params)
      super(:users, params, [:name, :nickname, :email, :password])

      @attr[:name]      = params[:name]
      @attr[:nickname]  = params[:nickname]
      @attr[:email]     = encrypt_emal(params[:email])
      @attr[:password]  = crypt_password(params[:password])
    end

    def validate
      not_null "User", @attr, :name
      not_null "User", @attr, :nickname
      not_null "User", @attr, :email
      not_null "User", @attr, :password
    end
  end
end