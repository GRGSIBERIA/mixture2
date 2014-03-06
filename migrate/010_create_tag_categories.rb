Sequel.migration do
  up do
    create_table(:tag_categories, :ignore_index_errors=>true) do
      primary_key :id
      DateTime :created_at
      
      foreign_key :tag_id,      :tags,       null: false
      foreign_key :category_id, :categories, null: false 
      index :tag_id
      index :category_id
    end
    
  end
end
