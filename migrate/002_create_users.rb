Sequel.migration do
  up do
    
    create_table(:users, :ignore_index_errors=>true) do
      primary_key :id
      String :name, :size=>255, :null=>false
      String :nickname, :size=>255, :null=>false
      String :password, :size=>255, :null=>false
      DateTime :created_at
      DateTime :updated_at
      
      index :name, unique: true
    end
    
  end
end
