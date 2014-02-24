require 'openssl'
require 'base64'
require "digest/sha2"

module Crypt
  def encrypt_password(password)
    Digest::SHA256.hexdigest(PASSWORD_SALT + password)
  end

  def make_apikey(user)
    user_name = user.name
    password = user.password
    key_base = Digest::SHA256.hexdigest(password + user_name)
  end

  module_function :make_apikey
  module_function :encrypt_password
end