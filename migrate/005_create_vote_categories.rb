Sequel.migration do
  up do
    create_table(:vote_categories, :ignore_index_errors=>true) do
      primary_key :id
      Integer :user_id, :null=>false
      Integer :tag_id, :null=>false
      Integer :category_id, :null=>false
      DateTime :created_at
      DateTime :updated_at
      
      foreign_key :user_id,     :users
      foreign_key :tag_id,      :tags
      foreign_key :category_id, :categories
      index [:category_id], :name=>:index_vote_categories_on_category_id
    end
    
  end
end
