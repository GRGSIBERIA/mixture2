#-*- encoding: utf-8
require './helpers/validation.rb'

module Model
  class ModelBase
    include Validation

    def check_accept(params, acceptance)
      raise_flag = false
      acceptance.each do |key|
        unless params.has_key?(key) then 
          raise ArgumentError, "必要なキーが存在していません: #{key.to_s}"
        end
      end
    end

    def initialize(table, params, acceptance)
      @table = table
      @attr = Hash.new
      @acceptance = acceptance
      @validate = []

      check_accept(params, acceptance)
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
      validate
      DB[@table].insert(@attr)
    end
  end
end