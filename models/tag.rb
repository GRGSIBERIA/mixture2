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
    tag_name = tag_name.downcase
    Model.find_or_create(Tag, {name: tag_name}, {name: tag_name, created_at: Time.now.to_s})
  end
end