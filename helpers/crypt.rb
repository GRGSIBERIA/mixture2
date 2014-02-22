require 'openssl'
require "digest/sha2"

module Crypt
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

  module_function :crypt_password
  module_function :encrypt_email
  module_function :decrypt_email
end