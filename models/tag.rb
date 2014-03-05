#-*- encoding: utf-8
class Tag < Sequel::Model
  plugin :validation_helpers
  many_to_one :categories
  one_to_many :vote_tags
  one_to_many :vote_categories

  def validate
    super
    validates_presence [:name, :category_id]

    validates_unique :name

    validates_format(/\A\w+\z/, :name)

    errors.add(:name, 'name include the invalid word.') if INVALID_WORDS.include?(name)
    errors.add(:name, 'name is only number.') if name =~ /\A\d+\z/
  end

  def self.find_create(tag_name)
    tag = Tag.find_or_create(name: tag_name) { |t| 
      t.name = tag_name
      t.category_id = 1
      t.created_at = Time.now.to_s
    }
  end

  def self.change_category(tag_id, category_name)
    tag = nil
    DB.transaction do 
      category = Category.find_create(category_name)
      Tag.where(id: tag_id).update(category_id: category.id)
    end
    tag
  end
end