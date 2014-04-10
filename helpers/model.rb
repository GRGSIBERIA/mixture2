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

  def find_or_create(class_name, find, params)
    class_name.find_or_create(find) {|inst|
      params.each do |k, v|
        inst[k] = v
      end
      inst.validate 
      raise ArgumentError, inst.errors.full_messages.join("<br>") unless inst.valid?
      inst
    }
  end

  module_function :find_or_create
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

  def basic_three_routing(class_name, type, params)
    route = class_name.to_s.downcase

    # params渡せないからしょうがない
    case type
    when :none
      return class_name.listing.to_json

    when :page_num
      page_num = params[:page_num].to_i 
      return class_name.listing(page_num).to_json

    when :order
      result = nil 
      begin
        page_num = params[:page_num].to_i
        order = params[:order]
        result = class_name.listing(page_num, order)
      rescue ArgumentError => e 
        raise_helper(e, params)
      end
      return result.to_json
    end
  end

  module_function :basic_three_routing
  module_function :listing_basic
end