Sequel.migration do
  up do
    
    create_table(:post_tags, :ignore_index_errors=>true) do
      primary_key :id
      Integer :count, :null=>false, :default=>0
      DateTime :created_at
      DateTime :updated_at
      
      foreign_key :tag_id, :tags , null: false
      foreign_key :post_id,:posts, null: false
      index [:tag_id, :post_id, :count], :name=>:index_post_tags_on_tag_id_and_post_id_and_count
    end
  end
end
