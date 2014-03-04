#-*- encoding: utf-8
class Category < Sequel::Model
  plugin :validation_helpers
  one_to_many :tags
  one_to_many :vote_categories

  def validate
    super
    validates_presence [:name]

    validates_unique :name
    
    validates_format(/\A\w+\z/, :name)

    errors.add(:name, 'name include the invalid word.') if INVALID_WORDS.include?(name)
    errors.add(:name, 'name is only number.') if name =~ /\A\d+\z/
  end

  def self.tags(category_id, page_num=0)
    ofst = page_num * NUMBER_OF_WORDS_PER_PAGE
    Tag.where(category_id: category_id.to_i)
      .order(Sequel.asc(:name))
      .offset(ofst)
      .limit(NUMBER_OF_WORDS_PER_PAGE)
  end

  def self.find_or_create(category_name)
    category = Category.find_or_create(name: category_name) {|c|
      c.name = category_name
      c.created_at = Time.now.to_s
      c.validate 
      raise ArgumentError, c.errors.full_messages.join("<br>") unless c.valid?
    }
    category
  end
end