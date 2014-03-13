#-*- encoding: utf-8
require 'openssl'
require 'base64'
require "digest/sha2"

class Crypt
  def self.encrypt(key, salt)
    enc = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
    enc.encrypt
    enc.pkcs5_keyivgen(salt)
    bin = enc.update(key) + enc.final
    Base64.encode64(bin)
  end

  def self.decrypt(key, salt)
    bin = Base64.decode64(key)
    dec = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
    dec.decrypt
    dec.pkcs5_keyivgen(salt)
    dec.update(bin) + dec.final
  end

  def self.encrypt_stretch(key, salt)
    digest = key + salt
    (0..4).each do |x|
      digest = Digest::SHA256.hexdigest(key + salt)
    end
    encrypt(digest, salt)
  end

  def self.check_decrypt(key, decrypted, salt)
    key = encrypt_stretch(key, salt)
    decrypted = decrypt(decrypted, salt)
    key == decrypted
  end

  def self.check_password(password, decrypted)
    check_decrypt(password, decrypted, PASSWORD_SALT)
  end

  def self.check_email(email, decrypted)
    check_decrypt(email, decrypted, EMAIL_SALT)
  end
end