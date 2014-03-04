Sequel.migration do
  up do
    
    create_table(:post_tags, :ignore_index_errors=>true) do
      primary_key :id
      DateTime :created_at
      
      foreign_key :tag_id, :tags , null: false
      foreign_key :post_id,:posts, null: false
      index [:tag_id, :post_id], :name=>:index_post_tags_on_tag_id_and_post_id
    end
  end
end
