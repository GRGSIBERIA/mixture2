#-*- encoding: utf-8

module Validation
  def not_null(cname, attribute, key)
    if param.nil? then
      raise ArgumentError, "#{cname}の#{key.to_s}が未入力です"
    end
  end

  def not_blank(param)
    
  end
end