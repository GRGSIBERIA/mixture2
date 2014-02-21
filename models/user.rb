class User < Sequel::Model
  unless table_exists?
    set_schema do 
      primary_key :id
      string :name, :size=>255, :null=>false
      string :nickname, :size=>255, :null=>false
      string :email, :size=>255, :null=>false
      string :password, :size=>255, :null=>false
      timestamp :created_at
      timestamp :updated_at
    end
    create_table
  end
end