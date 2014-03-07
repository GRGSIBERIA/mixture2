module Model
  def save_to_validate(instance)
    instance.validate
    raise ArgumentError, instance.errors.full_messages.join('<br>') unless instance.valid?
    instance.save
  end

  def exists(type, column, value)
    inst = type.find({column => value})
    if inst.nil? then
      raise ArgumentError, "#{type.to_s} #{column.to_s}(value) is not found.<br>"
    end
  end

  module_function :exists
  module_function :save_to_validate
end

module ListingHelper
  def listing_basic(db, per_page, page_num=0, order="desc")
    # 1ページあたりのコンテンツ数
    number_of_what_pp = nil
    case per_page 
    when :words
      number_of_what_pp = NUMBER_OF_WORDS_PER_PAGE
    when :contents
      number_of_what_pp = NUMBER_OF_CONTENTS_PER_PAGE
    end
    raise ArgumentError, "per_page(#{per_page.to_s}) is invalid parameter." if number_of_what_pp.nil?
    offset = number_of_what_pp * page_num

    # 並び順
    order_case = nil
    case order
    when "desc"
      order_case = Sequel.desc(:id)
    when "asc"
      order_case = Sequel.asc(:id)
    end
    raise ArgumentError, "order(#{order}) is invalid parameter." if order_case.nil?

    DB[db].order(order_case).offset(offset).limit(number_of_what_pp)
  end

  module_function :listing_basic
end