Sequel.migration do
  up do
    
    create_table(:users, :ignore_index_errors=>true) do
      primary_key :id
      String :name, :size=>128, :null=>false
      String :email, :size=>384, :null=>false
      String :password, :size=>128,  :null=>false
      DateTime :created_at
      
      index :name,  unique: true
      index :email, unique: true
    end
    
  end
end
