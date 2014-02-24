#-*- encoding: utf-8
class Post < Sequel::Model
  plugin :validation_helpers
  many_to_one :users
  one_to_many :vote_tags
  one_to_many :vote_categories
  one_to_many :post_tags
  one_to_many :thumbnails

  def validate
    super

  end
end