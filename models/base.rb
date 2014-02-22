#-*- encoding: utf-8

module Model
  class ModelBase
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

      check_accept(params, acceptance)
    end

    

    def insert!
      DB[@table].insert(@attr)
    end
  end
end