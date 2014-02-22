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

  def length(cname, attribute, key, params)
    if params.key?(:max) then
      if attribute[key].length > params[:max] then
        raise ArgumentError, "#{cname}の#{key.to_s}の長さが#{params[:max]}より大きいです"
      end
    end
    if params.key?(:min) then
      if attribute[key].length < params[:min] then
        raise ArgumentError, "#{cname}の#{key.to_s}の長さが#{params[:min]}より小さいです"
      end
    end
  end

  module_function :not_null
  module_function :not_blank
  module_function :length
end