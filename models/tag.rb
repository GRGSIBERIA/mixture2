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
        DB[:tags].where(id: tag.to_i).first  
      else
        DB[:tags].where(name: tag).first
      end
    when Integer
      DB[:tags].where(id: tag).first
    end
  end

  def self.vote(user_id, post_id, tag_name)
    tag = Tag.find(tag_name)
  end
end