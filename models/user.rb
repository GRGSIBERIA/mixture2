
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
      validates :not_null, :name
      validates :not_null, :nickname
      validates :not_null, :email
      validates :not_null, :password

      validates :not_blank, :name
      validates :not_blank, :nickname
      validates :not_blank, :email
      validates :not_blank, :password

      validates :length, :name,     max: 80,  min: 5
      validates :length, :nickname, max: 80
      validates :length, :email,    max: 256, min: 6
    end
  end
end