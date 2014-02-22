#-*- encoding: utf-8
require './helpers/validation.rb'

module Models
  class ModelBase
    include Validation

    def self.inherited(child)
      @@child = child
    end

    def check_accept(params, acceptance)
      raise_flag = false
      acceptance.each do |key|
        unless params.has_key?(key) then 
          raise ArgumentError, "必要なキーが存在していません: #{key.to_s}"
        end
      end
    end

    def initialize(table, params, acceptance)
      @child = @@child
      @table = table
      @attr = Hash.new
      @acceptance = acceptance
      @validate = []

      check_accept(params, acceptance)
    end

    def validation
      @validate.each do |x|
        Validation.method(x[0]).call(@child, @attr, x[1], x[2])
      end
    end

    def validates(method, column, params={})
      @validate << [method, column, params]
    end

    def shave_attribute
      buffer = Hash.new
      @acceptance.each do |key|
        buffer[key] = @attr[key]
      end
      @attr = buffer
    end

    def insert!
      shave_attribute
      validation
      DB[@table].insert(@attr)
    end

    def update!
      shave_attribute
      validation
      DB[@table].update(@attr)
    end

    def delete!
      
    end

    def []=(key, value)
      if !@acceptance.key?(key) then
        raise ArgumentError, "#{@child}で存在しないキー(#{key})が呼び出されました"
      end
      @attr[key] = value
    end

    def [](key)
      if !@acceptance.key?(key) then
        raise ArgumentError, "#{@child}で存在しないキー(#{key})が呼び出されました"
      end
      @attr[key]
    end
  end
end