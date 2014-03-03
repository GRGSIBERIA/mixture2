#-*- encoding: utf-8
class Tag < Sequel::Model
  plugin :validation_helpers
  many_to_one :categories
  one_to_many :vote_tags
  one_to_many :vote_categories

  def validate
    super
    validates_presence [:name]

    validates_length_range 4..140, :name

    validates_unique :name

    validates_format(/\A\w+\z/, :name)

    errors.add(:name, 'name include the invalid word.') if INVALID_WORDS.include?(name)
    errors.add(:name, 'name is only number.') if name =~ /\A\d+\z/
  end

  def self.create(tag_name)
    tag = nil
    DB.transaction do 
      tag = Tag.new
      tag.name = tag_name
      tag.category_id = 1
      tag.created_at = Time.now.to_s
      Model.save_to_validate(tag)

      Category.where(id: tag.category_id).update(count: Sequel.+(:count, 1))
    end
    tag
  end

  def self.change_category(tag_id, category_name)
    tag = nil
    DB.transaction do 
      tag = Tag.find(id: tag_id)

      Category.where(id: tag.category_id).update(count: Sequel.-(:count, 1))
      Category.where(name: category_name).update(count: Sequel.+(:count, 1))

      category = Category.find(name: category_name)

      tag.category_id = category.id
      tag.save
    end
    tag
  end
end