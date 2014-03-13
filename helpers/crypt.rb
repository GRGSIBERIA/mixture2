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

  def self.encrypt_password(password)
    digest = password + PASSWORD_SALT
    (0..4).each do |x|
      digest = Digest::SHA256.hexdigest(digest + PASSWORD_SALT)
    end
    password = encrypt(digest, PASSWORD_SALT)
  end

  def self.check_password(password, decrypted)
    password = encrypt_password(password)
    decrypted = decrypt(decrypted, PASSWORD_SALT)
    password == decrypted
  end

  def self.make_apikey(user)
    user_name = user.name
    password = user.password
    key_base = Digest::SHA256.hexdigest(password + user_name)
  end
end