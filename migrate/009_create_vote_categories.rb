Sequel.migration do
  up do
    
    create_table(:vote_categories, :ignore_index_errors=>true) do
      primary_key :id
      Integer :vote, null: false
      DateTime :created_at
      
      foreign_key :user_id,         :users,          null: false
      foreign_key :tag_category_id, :tag_categories, null: false
      unique [:user_id, :tag_category_id]
      index :tag_category_id
    end
  end
end
