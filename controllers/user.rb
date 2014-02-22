require 'digest/sha2'
require './models/user.rb'

module Controller
  class User
    def self.crypt_password(password)
      Digest::SHA256.hexdigest(PASSWORD_SALT + password)
    end

    def self.create(params)
      user = {
        password: crypt_password(params[:password]),
        name: params[:username],
        nickname: params[:nickname],
        email: params[:email]
      } 
      Model::User

    end
  end
end