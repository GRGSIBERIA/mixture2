Sequel.migration do
  up do
    
    create_table(:vote_tags, :ignore_index_errors=>true) do
      primary_key :id
      DateTime :created_at
      DateTime :updated_at
      
      foreign_key :user_id, :users, null: false
      foreign_key :tag_id,  :tags,  null: false
      foreign_key :post_id, :posts, null: false
      index [:tag_id, :post_id], :name=>:index_vote_tags_on_tag_id_and_post_id
    end
  end
end
