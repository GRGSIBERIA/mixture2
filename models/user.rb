#-*- encoding: utf-8

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

      validates :format, :name,     with: /\A\w+\z/
      validates :format, :nickname, with: /\A[\wぁ-んァ-ヴ一-龠、-◯]\z/u
      validates :format, :email,    with: /\A[a-zA-Z0-9_¥.¥-]+@[A-Za-z0-9_¥.¥-]+\.[A-Za-z0-9_¥.¥-]+\z/
    end
  end
end