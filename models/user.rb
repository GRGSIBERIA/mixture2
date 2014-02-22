
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
      validates :not_blank, :name
      validates :not_blank, :nickname
      validates :not_blank, :email
      validates :not_blank, :password

      validates :length, :name,     max: 80,  min: 5
      validates :length, :nickname, max: 80
      validates :length, :email,    max: 256, min: 6

      validates :prohibition_word, :name
      validates :prohibition_word, :nickname
      validates :prohibition_word, :email
    end
  end
end