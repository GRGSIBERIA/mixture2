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

  def self.create(tag_name)
    tag = Tag.new
    tag.name = tag_name
    tag.category_id = 1.to_s
    tag.created_at = Time.now.to_s
    tag.validate
    unless tag.valid? then
      raise ArgumentError, "duplicate tag name(#{tag_name})."
    end
    tag.save

    
    tag
  end
end