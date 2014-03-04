Sequel.migration do
  up do
    create_table(:categories, :ignore_index_errors=>true) do
      primary_key :id
      String :name, :size=>255, :null=>false
      Integer :count, :default=>0, :null=>false
      DateTime :created_at
      
      index :name, unique: true
    end
    
  end
end
