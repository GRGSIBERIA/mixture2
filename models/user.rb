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

    validates_unique [:name, :email]

    validates_format(/\A\w+\z/, :name)
    validates_format(/\A[\w#{Moji.zen}]+\z/, :nickname)

    errors.add(:name, 'use the invalid word') if INVALID_WORDS.include?(name)
    errors.add(:nickname, 'use the invalid word') if INVALID_WORDS.include?(name)
  end

  def self.add(params)
    password = Crypt.crypt_password(params[:password])
    email = Crypt.encrypt_email(params[:email])
    User.new({
      name:     params[:username],
      nickname: params[:nickname],
      password: password,
      email:    email,
      })
  end
end