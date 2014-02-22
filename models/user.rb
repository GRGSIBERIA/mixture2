#-*- encoding: utf-8
class User < Sequel::Model
  one_to_many :posts
  one_to_many :vote_tags
  one_to_many :vote_categories

  def validate
    super
    
  end
end