Sequel.migration do
  up do
    
    create_table(:tags, :ignore_index_errors=>true) do
      primary_key :id
      String :name, :size=>255, :null=>false
      Integer :count, :default=>0, :null=>false
      DateTime :created_at
      
      foreign_key :category_id, :categories, null: false, default: 1
      index [:category_id], :name=>:index_tags_on_category_id
      index [:name], :name=>:index_tags_on_name, :unique=>true
    end
    
  end
end
