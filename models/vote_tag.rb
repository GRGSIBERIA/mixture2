#-*- encoding: utf-8
class VoteTag < Sequel::Model
  plugin :validation_helpers
  many_to_one :tags
  many_to_one :users
  many_to_one :posts

  def validate
    super
    
  end
end