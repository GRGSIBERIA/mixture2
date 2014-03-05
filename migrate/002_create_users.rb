Sequel.migration do
  up do
    
    create_table(:users, :ignore_index_errors=>true) do
      primary_key :id
      String :name, :size=>128, :null=>false
      String :nickname, :size=>128, :null=>false
      String :password, :size=>66,  :null=>false
      String :open_key, :size=>66,  :null=>false
      DateTime :created_at
      
      index :name,     unique: true
      index :open_key, unique: true
    end
    
  end
end
