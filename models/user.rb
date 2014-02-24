#-*- encoding: utf-8
require 'digest/sha2'
require './helpers/crypt.rb'

class User < Sequel::Model
  include Crypt
  plugin :validation_helpers
  one_to_many :posts
  one_to_many :vote_tags
  one_to_many :vote_categories

  def validate
    super
    validates_presence [:name, :email, :password, :nickname]

    validates_length_range 4..80, :name
    validates_length_range 4..80, :nickname
    validates_length_range 4..80, :password
    validates_length_range 6..256,:email

    validates_unique [:name, :email]

    validates_format(/\A\w+\z/, :name)
    validates_format(/\A[\w#{Moji.zen}]+\z/, :nickname)
    validates_format(%r{^(?:(?:(?:(?:[a-zA-Z0-9_!#$%&'*+/=?^`{}~|-]+)(?:.(?:[a-zA-Z0-9_!#$%&'*+/=?^`{}~|-]+))*)|(?:"(?:\[^ ]|[^\"])*")))@(?:(?:(?:(?:[a-zA-Z0-9_!#$%&'*+/=?^`{}~|-]+)(?:.(?:[a-zA-Z0-9_!#$%&'*+/=?^`{}~|-]+))*)|(?:[(?:\S|[!-Z^-~])*])))$}, :email)

    errors.add(:name, 'use the invalid word') if INVALID_WORDS.include?(name)
    errors.add(:nickname, 'use the invalid word') if INVALID_WORDS.include?(name)

    password = Crypt.crypt_password(password)
    email = Crypt.encrypt_email(email)
  end

  def self.add(params)
    User.new({
      name:     params[:user_name],
      nickname: params[:nickname],
      password: params[:password],
      email:    params[:email],
      })
  end
end