require 'digest/sha2'
require 'openssl'

module Model
  class User < Model::Base
    def crypt_password(password)
      Digest::SHA256.hexdigest(PASSWORD_SALT + password)
    end

    def decrypt_email(address)
      dec = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
      dec.decrypt.pkcs5_keyivgen(address)
      dec.update(PASSWORD_SALT) + dec.final
    end

    def encrypt_email(address)
      enc = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
      enc.encrypt.pkcs5_keyivgen(address)
      enc.update(PASSWORD_SALT) + enc.final
    end

    def initialize(params)
      super(params, [:name, :nickname, :email, :password])

      @attr[:id]        = DB[:users].count + 1
      @attr[:name]      = params[:name]
      @attr[:nickname]  = params[:nickname]
      @attr[:email]     = encrypt_emal(params[:email])
      @attr[:password]  = crypt_password(params[:password])
    end

    def insert!

    end
  end
end