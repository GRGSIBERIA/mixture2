Sequel.migration do
  up do
    
    create_table(:thumbnails, :ignore_index_errors=>true) do
      primary_key :id
      String :file_name, :size=>255, :null=>false
      DateTime :created_at
      DateTime :updated_at
      
      foreign_key :post_id,:posts, null: false
      index [:post_id], :name=>:index_thumbnails_on_post_id
    end
  end
end
