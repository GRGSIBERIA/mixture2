#-*- encoding: utf-8

module Model
  class ModelBase
    def initialize(params, acceptance)
      raise_flag = false
      acceptance.each do |key|
        unless params.has_key?(key) then 
          raise ArgumentError, "必要なキーが存在していません: #{key.to_s}"
        end
      end
    end

    def insert_base(table, attribute)
      DB[table].insert(attribute)
    end
  end
end