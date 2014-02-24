require 'openssl'
require 'base64'
require "digest/sha2"

module Crypt
  def crypt_password(password)
    Digest::SHA256.hexdigest(PASSWORD_SALT + password)
  end

  def decrypt_email(address)
    dec = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
    address = Base64::decode64(address)
    dec.decrypt.pkcs5_keyivgen(PASSWORD_SALT)
    dec.update(address) + dec.final
  end

  def encrypt_email(address)
    enc = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
    enc.encrypt.pkcs5_keyivgen(PASSWORD_SALT)
    pass = enc.update(address) + enc.final
    Base64::encode64(pass)
  end

  module_function :crypt_password
  module_function :encrypt_email
  module_function :decrypt_email
end