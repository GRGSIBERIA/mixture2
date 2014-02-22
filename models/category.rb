#-*- encoding: utf-8
class Category < Sequel::Model
  one_to_many :tags
  one_to_many :vote_categories

  def validate
    super
    
  end
end