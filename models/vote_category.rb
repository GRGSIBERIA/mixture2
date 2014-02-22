#-*- encoding: utf-8
class VoteCategory < Sequel::Model
  many_to_one :users
  many_to_one :tags
  many_to_one :categories

  def validate
    super
    
  end
end