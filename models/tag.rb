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
  end

  def self.find(tag)
    case tag 
    when String
      if tag =~ /\A\d+\z/ then
        buf = DB[:tags].where(id: tag.to_i).first  
        if buf.nil? then
          halt 400, "Do not found tag_id."
        end
      else
        DB[:tags].where(name: tag).first
      end
    when Integer
      buf = DB[:tags].where(id: tag).first
      if buf.nil? then
        halt 400, "Do not found tag_id."
      end
    end
  end

  def self.find_or_create(tag_name)
    if tag_name.class == String then
      unless tag =~ /\A\d+\z/ then
        Tag.new(name: tag_name, created_at: Time.now.to_s)
      else
        halt 400, "tag_name is not a tag name"
      end
    else
      halt 400, "tag_name is not a tag name."
  end

  def self.vote(user_id, post_id, tag_name)
    tag = Tag.find(tag_name)
    post = Post.find(post_id)
    user = User.find(user_id)
  end
end