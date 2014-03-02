Sequel.migration do
  up do
    
    create_table(:thumbnails, :ignore_index_errors=>true) do
      primary_key :id
      String :primary_thumb, null: false, size: 2, default: "f"
      DateTime :created_at
      
      foreign_key :post_id,:posts, null: false
      index [:post_id], :name=>:index_thumbnails_on_post_id
    end
  end
end
