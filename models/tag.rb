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

  def self.create(tag_name)
    tag = nil
    DB.transaction do 
      tag = Tag.new(name: tag_name, category_id: 1, created_at: Time.now.to_s)
      Model.save_to_validate(tag)
    end
    tag
  end

  def self.find_or_create(tag_name)
    tag = Tag.find(name: tag_name)
    if tag.nil? then
      tag = Tag.create(tag_name)
    end
    tag
  end

  def self.change_category(tag_id, category_name)
    tag = nil
    DB.transaction do 
      tag = Tag.find(id: tag_id)
      if tag.nil? then
        raise ArgumentError, "tag_id(#{tag_id}) is not found."
      end
      category = Category.find_or_create(category_name)
      tag.category_id = category.id
      tag.save
    end
    tag
  end

  def self.vote_tag(tag_id, post_id, user_id)
    DB.transaction do 
      user = User.exists_id(user_id)
      post_tag = PostTag.find_or_create(post_id, tag_id)
      vote_tag = VoteTag.find_or_create(post_tag, user_id, 1)
    end
  end
end