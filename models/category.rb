#-*- encoding: utf-8
class Category < Sequel::Model
  plugin :validation_helpers

  def validate
    super
    validates_presence [:name]

    validates_unique :name
    
    validates_format(/\A\w+\z/, :name)

    errors.add(:name, 'name include the invalid word.') if INVALID_WORDS.include?(name)
    errors.add(:name, 'name is only number.') if name =~ /\A\d+\z/
  end

  def self.find_create(category_name)
    category = Category.find_or_create(name: category_name) {|c|
      c.name = category_name
      c.created_at = Time.now.to_s
      c.validate 
      raise ArgumentError, c.errors.full_messages.join("<br>") unless c.valid?
    }
    category
  end
end