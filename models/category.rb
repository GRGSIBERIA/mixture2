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

  def self.tags(category_id, page_num=0)
    ofst = page_num * NUMBER_OF_WORDS_PER_PAGE
    DB[:tags]
      .where(category_id: category_id.to_i)
      .order(Sequel.asc(:name))
      .offset(ofst)
      .limit(NUMBER_OF_WORDS_PER_PAGE)
  end
end