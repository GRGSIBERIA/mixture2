#-*- encoding: utf-8
class Tag < Sequel::Model
  plugin :validation_helpers
  many_to_one :categories
  one_to_many :vote_tags
  one_to_many :vote_categories

  def validate
    super
    validates_presence [:name]

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
      Category.where(id: tag.category_id).update(count: Sequel.+(:count, 1))
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
      Category.where(id: tag.category_id).update(count: Sequel.-(:count, 1))

      category = Category.find_or_create(category_name)
      Category.where(id: category.id).update(count: Sequel.+(:count, 1))
      tag.category_id = category.id
      tag.save
    end
    tag
  end

  def self.vote_tag(tag_id, post_id, user_id)
    DB.transaction do 
      vote_tag = VoteTag.create(tag_id, post_id, user_id)
      
      post_tag = PostTag.where(post_id, tag_id).first
      if post_tag.nil? then
        # 存在しない場合は新しく作成
        post_tag = PostTag.new(post_id: post_id, tag_id: tag_id)
        post_tag.count = 1
        post_tag.save
      else
        # 存在する場合はアップデート
        PostTag.where(id: post_tag.id).update(count: Sequel.+(:count, 1))
      end
    end
  end
end