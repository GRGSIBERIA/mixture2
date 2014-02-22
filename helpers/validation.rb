#-*- encoding: utf-8

module Validation
  def not_null(cname, attribute, key, params)
    if attribute[key].nil? then
      raise ArgumentError, "#{cname}の#{key.to_s}がnilです"
    end
  end

  def not_blank(cname, attribute, key, params)
    if attribute[key].blank? then
      raise ArgumentError, "#{cname}の#{key.to_s}が空です"
    end
  end

  def max_length(cname, attribute, key, params)
    
  end

  module_function :not_null
  module_function :not_blank
end