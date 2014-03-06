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
    TagCategory.find_or_create(tag_id: tag_id, category_id: category_id) { |c| 
      c.tag_id = tag_id
      c.category_id = category_id
      c.created_at = Time.now.to_s
      c.validate 
      raise ArgumentError, c.errors.full_messages.join("<br>") unless c.valid?
    }
  end
end