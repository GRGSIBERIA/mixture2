
module Models
  class User < Model::Base
    include Crypt

    def initialize(params)
      super(:users, params, [:name, :nickname, :email, :password])

      @attr[:id]        = DB[:users].count + 1
      @attr[:name]      = params[:name]
      @attr[:nickname]  = params[:nickname]
      @attr[:email]     = encrypt_emal(params[:email])
      @attr[:password]  = crypt_password(params[:password])
    end
  end
end