Sequel.migration do
  up do
  
    create_table(:posts, :ignore_index_errors=>true) do
      primary_key :id
      String :file_hash, :size=>66, :null=>false
      String :extension, :size=>12, :null=>false
      DateTime :created_at
      
      foreign_key :user_id, :users, null: false
      index :user_id
    end
    
  end
end

