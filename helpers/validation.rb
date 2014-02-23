#-*- encoding: utf-8

module Validation
  def is_blank(target, att, params)
    if params[att].empty? or params[att].nil? then
      target.errors.add(att, 'is not present')
    end
  end

  def in_range(target, att, params, min, max)
    unless params[att].length < max or params[att] > min then
      target.errors.add(att, 'is too short or too long')
    end
  end

  module_function :is_blank
  module_function :in_range
end