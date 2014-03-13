#-*- encoding: utf-8
require 'digest/sha2'
require './helpers/crypt.rb'

class User < Sequel::Model
  include Crypt
  plugin :validation_helpers
  one_to_many :posts
  one_to_many :vote_tags
  one_to_many :vote_categories
  one_to_many :post_pushes

  def validate
    super
    validates_presence [:name, :email, :password]

    validates_length_range 4..128, :name

    validates_unique :name
    validates_unique :email

    validates_format(/\A\w+\z/, :name)
    validates_format(/\A[a-zA-Z0-9_\.\-]+@[A-Za-z0-9_\.\-]+\.[A-Za-z0-9_\.\-]+\z/, :email)

    errors.add(:name, 'is the invalid word') if INVALID_WORDS.include?(name)
  end

  def self.check_as_create(name, email, password)
    user = User.new(
      name: name,
      password: Model.encrypt_password(password),
      email:    Model.encrypt_email(email))
    user.validate 
    raise ArgumentError, user.errors.full_messages.join("<br>") unless user.valid?
    user
  end

  def self.add(params)
    user = User.new({
      name:     params[:user_name],
      nickname: params[:nickname],
      password: Crypt.encrypt_password(params[:password]),
      open_key: "hogehoge",
      created_at: Time.now.to_s
      })
  end

  def self.listing(page_num=0, order="desc")
    ListingHelper.listing_basic(:users, :words, page_num, order)
  end

  def self.posts(user_id, page_num=0)
    offset = page_num.to_i * NUMBER_OF_CONTENTS_PER_PAGE
    DB[:posts]
      .where(user_id: user_id.to_i)
      .order(Sequel.desc(:id))
      .offset(offset)
      .limit(NUMBER_OF_CONTENTS_PER_PAGE)
  end
end