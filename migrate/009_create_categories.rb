Sequel.migration do
  up do
    create_table(:categories, :ignore_index_errors=>true) do
      primary_key :id
      String :name, :size=>128, :null=>false
      Integer :count, :default=>0, :null=>false
      DateTime :created_at
      
      foreign_key :tag_id, :tags, null: false
      index :tag_id
      index :name, unique: true
    end
    
  end
end
