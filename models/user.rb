#-*- encoding: utf-8
class User < Sequel::Model
  plugin :validation_helpers
  one_to_many :posts
  one_to_many :vote_tags
  one_to_many :vote_categories

  def validate
    super
    validates_presence [:name, :email, :password, :nickname]
    validates_min_length 4, :name
    validates_min_length 4, :nickname
  end
end