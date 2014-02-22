#-*- encoding: utf-8

module Validation
  def not_null(cname, attribute, key)
    if attribute[key].nil? then
      raise ArgumentError, "#{cname}の#{key.to_s}がnilです"
    end
  end

  def not_blank(cname, attribute, key)
    if attribute[key].blank? then
      raise ArgumentError, "#{cname}の#{key.to_s}が空です"
    end
  end
end