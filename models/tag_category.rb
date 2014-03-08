#-*- encoding: utf-8
class TagCategory < Sequel::Model
  plugin :validation_helpers
  one_to_many :tags
  one_to_many :categories

  def validate
    super

    validates_presence [:tag_id, :category_id]
    
    validates_integer :tag_id
    validates_integer :category_id
  end

  def self.check_as_create(tag_id, category_id)
    Model.find_or_create(TagCategory, 
      {tag_id: tag_id, category_id: category_id}, 
      {tag_id: tag_id, category_id: category_id, created_at: Time.now.to_s})
  end
end