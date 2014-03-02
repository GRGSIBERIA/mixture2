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

  def self.create(category_name)
    category = Category.new
    category.name = category_name
    category.created_at = Time.now.to_s
    Validation.save_to_validate(instance)
    category
  end

  def self.countup(category_id)
    category = DB[:categories]
      .where(id: category_id)
      .update(count: Sequel.+(:count, 1))
  end

  def self.countdown(category_id)
    category = DB[:categories]
      .where(id: category_id)
      .update(count: Sequel.-(:count, 1))
  end
end