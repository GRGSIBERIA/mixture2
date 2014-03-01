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

    errors.add(:name, 'use the invalid word') if INVALID_WORDS.include?(name)
    errors.add(:name, 'use only numerical') if name =~ /\A\d+\z/
  end

  def self.find(tag)
    case tag 
    when String
      if tag =~ /\A\d+\z/ then
        buf = DB[:tags].where(id: tag.to_i).first  
        if buf.nil? then
          halt 400, "Do not found tag_id(#{tag})."
        end
      else
        DB[:tags].where(name: tag).first
      end
    when Integer
      buf = DB[:tags].where(id: tag).first
      if buf.nil? then
        halt 400, "Do not found tag_id(#{tag})."
      end
    end
  end

  def self.countup(tag_inst)
    cnt = tag_inst.count + 1
    tag_inst.update(count: cnt)
  end

  def self.countdown(tag_inst)
    cnt = tag_inst.count - 1
    tag_inst.update(count: cnt)
  end

  def self.create(tag_name)
    tag = Tag.new(name: tag_name, category_id: 1, created_at: Time.now.to_s)
    tag.validate
    unless tag.valid? then
      halt 400, "Cannot created a tag name(#{tag_name})."
    else
      tag.save
    end
    tag
  end

  def self.find_or_create(tag_name)
    tag = Tag.find(tag_name)
    if tag.nil? then
      Tag.create(tag_name)
    else
      return tag
    end
  end

  def self.to_i(inst)
    case inst
    when String
      if inst =~ /\A\d+\z/ then
        return inst.to_i
      end
    when Integer
      return inst
    end
    nil
  end

  def self.vote(user_id, post_id, tag_name)
    tag = Tag.find_or_create(tag_name)
    user_id = Tag.to_i(user_id)
    post_id = Tag.to_i(post_id)
    
    PostTag.vote(user_id, post_id, tag.id)
  end
end