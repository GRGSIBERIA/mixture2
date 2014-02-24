Sequel.migration do
  up do
  
    create_table(:posts, :ignore_index_errors=>true) do
      primary_key :id
      Integer :user_id, :null=>false
      String :file_hash, :size=>255, :null=>false
      String :file_name, :size=>255, :null=>false
      Integer :file_size, :null=>false
      DateTime :created_at
      DateTime :updated_at
      
      index [:user_id], :name=>:index_posts_on_user_id
    end
    
  end
end
