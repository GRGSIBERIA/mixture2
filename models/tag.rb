#-*- encoding: utf-8
class Tag < Sequel::Model
  many_to_one :categories
  one_to_many :vote_tags
  one_to_many :vote_categories

  def validate
    super
    
  end
end