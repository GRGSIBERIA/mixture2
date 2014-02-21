Sequel.migration do
  up do
    create_table(:vote_categories, :ignore_index_errors=>true) do
      primary_key :id
      Integer :user_id, :null=>false
      Integer :tag_id, :null=>false
      Integer :category_id, :null=>false
      DateTime :created_at
      DateTime :updated_at
      
      index [:category_id], :name=>:index_vote_categories_on_category_id
    end
    
  end
end
