#-*- encoding: utf-8
class VoteTag < Sequel::Model
  many_to_one :tags
  many_to_one :users
  many_to_one :posts
end