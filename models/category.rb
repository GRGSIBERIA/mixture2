#-*- encoding: utf-8
class Category < Sequel::Model
  plugin :validation_helpers
  one_to_many :tags
  one_to_many :vote_categories

  def validate
    super
    validates_presence [:name]

    validates_length_range 4..140, :name

    validates_unique :name
    
    validates_format(/\A\w+\z/, :name)

    errors.add(:name, 'use the invalid word') if INVALID_WORDS.include?(name)
  end

  def self.find(id)
    DB[:categories].where(id: id.to_i).first
  end

  def self.tags(category)
    
  end
end