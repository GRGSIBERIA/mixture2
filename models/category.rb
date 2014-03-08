#-*- encoding: utf-8
class Category < Sequel::Model
  include ListingHelper
  plugin :validation_helpers
  one_to_many :tag_categories

  def validate
    super
    validates_presence [:name]

    validates_unique :name
    
    validates_format(/\A\w+\z/, :name)

    errors.add(:name, 'name include the invalid word.') if INVALID_WORDS.include?(name)
    errors.add(:name, 'name is only number.') if name =~ /\A\d+\z/
  end

  def self.find_create(category_name)
    Model.find_or_create(Category, {name: category_name}, {name: category_name, created_at: Time.now.to_s})
  end

  def self.listing(page_num=0, order="desc")
    ListingHelper.listing_basic(:categories, :words, page_num, order)
  end
end