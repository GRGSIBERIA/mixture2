Sequel.migration do
  up do
    
    create_table(:post_pushes, :ignore_index_errors=>true) do
      String   :file_hash, primary_key: true
      DateTime :created_at

      foreign_key :user_id, :users
    end
  end
end
