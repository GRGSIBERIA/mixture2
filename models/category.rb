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

    errors.add(:name, 'name include the invalid word.') if INVALID_WORDS.include?(name)
    errors.add(:name, 'name is only number.') if name =~ /\A\d+\z/
  end

  def self.tags(category_id, page_num=0)
    ofst = page_num * NUMBER_OF_WORDS_PER_PAGE
    DB[:tags]
      .where(category_id: category_id.to_i)
      .order(Sequel.asc(:name))
      .offset(ofst)
      .limit(NUMBER_OF_WORDS_PER_PAGE)
  end

  def self.create(category_name)
    category = Category.new(name: category_name, created_at: Time.now.to_s)
    Model.save_to_validate(category)
    category
  end

  def self.find_or_create(category_name)
    category = Category.find(name: category_name)
    if category.nil? then
      category = Category.create(category_name)
    end
    category
  end
end