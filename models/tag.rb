#-*- encoding: utf-8
class Tag < Sequel::Model
  plugin :validation_helpers
  one_to_many :post_tags

  def validate
    super
    validates_presence [:name]

    validates_unique :name

    validates_format(/\A\w+\z/, :name)

    errors.add(:name, 'name include the invalid word.') if INVALID_WORDS.include?(name)
    errors.add(:name, 'name is only number.') if name =~ /\A\d+\z/
  end

  def self.find_create(tag_name)
    tag = Tag.find_or_create(name: tag_name) { |t| 
      t.name = tag_name
      t.created_at = Time.now.to_s
      t.validate 
      raise ArgumentError, "#{tag_name} is invalid name." unless t.valid?
    }
  end
end