Sequel.migration do
  up do
    
    create_table(:vote_tags, :ignore_index_errors=>true) do
      primary_key :id
      Integer :vote_unvote, null: false
      DateTime :created_at
      
      foreign_key :user_id, :users, null: false
      foreign_key :post_tag_id, :posts, null: false
      unique [:user_id, :post_tag_id]
      index :post_tag_id
    end
  end
end
