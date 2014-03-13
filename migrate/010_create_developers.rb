Sequel.migration do
  up do
    
    create_table(:developers, :ignore_index_errors=>true) do
      primary_key :id
      String :secret_key,   :size=>128
      String :consumer_key, :size=>128
      DateTime :created_at
      
      foreign_key :user_id, :users, null: false
      index :user_id, unique: true
    end
  end
end
