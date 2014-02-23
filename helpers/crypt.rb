require 'openssl'
require 'base64'
require "digest/sha2"

module Crypt
  def crypt_password(password)
    Digest::SHA256.hexdigest(PASSWORD_SALT + password)
  end

  def decrypt_email(address)
    dec = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
    dec.decrypt.pkcs5_keyivgen(PASSWORD_SALT)
    pass = dec.update(address) + dec.final
    Base64::b64encode(pass)
  end

  def encrypt_email(address)
    enc = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
    address = Base64::b64decode(address)
    enc.encrypt.pkcs5_keyivgen(PASSWORD_SALT)
    enc.update(address) + enc.final
  end

  module_function :crypt_password
  module_function :encrypt_email
  module_function :decrypt_email
end