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

  def self.find(tag)
    Model.find(:tags, tag)
  end

  def self.create(tag_name)
    tag = nil
    DB.transaction
      tag = Tag.new
      tag.name = tag_name
      tag.category_id = 1
      tag.created_at = Time.now.to_s
      Validation.save_to_validate(tag)

      Category.countup(tag.category_id)
    end
    tag
  end

  def self.countup(tag)
    Model.countup(:tags, tag)
  end

  def self.countdown(tag)
    Model.countdown(:tags, tag)
  end

  def self.change_category(tag_name, category_name)
    tag = nil
    DB.transaction do 
      tag = Tag.find(tag_name)

      Category.countdown(tag.category_id)
      Category.countup(category_name)

      category = Category.find(category_name)
      tag.category_id = category.id
      tag.save
    end
    tag
  end
end