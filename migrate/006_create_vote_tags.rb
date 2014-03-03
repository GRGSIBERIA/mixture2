Sequel.migration do
  up do
    
    create_table(:vote_tags, :ignore_index_errors=>true) do
      primary_key :id
      Integer :vote_unvote, null: false
      DateTime :created_at
      
      foreign_key :user_id, :users, null: false
      foreign_key :post_tag_id, :posts, null: false
      index [:post_tag_id], :name=>:index_vote_tags_on_post_tag_id
    end
  end
end
