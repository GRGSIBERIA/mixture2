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
    validates_presence [:name, :password, :nickname]

    validates_length_range 4..80, :name
    validates_length_range 4..80, :nickname

    validates_unique :name

    validates_format(/\A\w+\z/, :name)
    validates_format(/\A[\w#{Moji.zen}]+\z/, :nickname)

    errors.add(:name, 'is the invalid word') if INVALID_WORDS.include?(name)
    errors.add(:nickname, 'is the invalid word') if INVALID_WORDS.include?(name)
  end

  def self.add(params)
    User.new({
      name:     params[:user_name],
      nickname: params[:nickname],
      password: Crypt.encrypt_password(params[:password]),
      created_at: Time.now.to_s,
      updated_at: Time.now.to_s
      })
  end

  def self.find(id)
    case id 
    when String
      if id =~ /\A\d+\z/ then
        return DB[:users].where(id: id.to_i).first
      else
        return DB[:users].where(name: id).first
      end
    when Integer
      return DB[:users].where(id: id).first
    end
  end

  def self.call_order_query(page_num, order)
    page = params[:page_num].to_i * 50
    DB[:users].select(:id, :name, :nickname, :created_at)
      .order(order)
      .offset(page).limit(50)
  end

  def self.order_by_new(page_num=0)
    User.call_order_query(Sequel.desc(:id))
  end

  def self.order_by_old(page_num=0)
    User.call_order_query(Sequel.asc(:id))
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