#-*- encoding: utf-8
class Tag < Sequel::Model
  many_to_one :categories
  many_to_one :posts
  one_to_many :vote_tags
  one_to_many :vote_categories
end