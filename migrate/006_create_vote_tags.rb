Sequel.migration do
  up do
    
    create_table(:vote_tags, :ignore_index_errors=>true) do
      primary_key :id
      Integer :user_id, :null=>false
      Integer :tag_id, :null=>false
      Integer :post_id, :null=>false
      DateTime :created_at
      DateTime :updated_at
      
      index [:tag_id, :post_id], :name=>:index_vote_tags_on_tag_id_and_post_id
    end
  end
end