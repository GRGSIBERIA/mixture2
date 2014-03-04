Sequel.migration do
  up do
    create_table(:vote_categories, :ignore_index_errors=>true) do
      primary_key :id
      DateTime :created_at
      
      foreign_key :user_id,     :users,     null: false
      foreign_key :tag_id,      :tags,      null: false
      foreign_key :category_id, :categories,null: false
      index :category_id
    end
    
  end
end
