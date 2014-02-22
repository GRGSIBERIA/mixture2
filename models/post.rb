#-*- encoding: utf-8
class Post < Sequel::Model
  many_to_one :users
  one_to_many :vote_tags
  one_to_many :vote_categories
  one_to_many :post_tags

  def validate
    super
    
  end
end