class Connector
  def self.mysql
    dbconfig = YAML::load_file("./config/database.yml")
    Sequel::Model.plugin(:schema)
    dbopts = Hash.new
    mode = "development"
    dbopts[:host] = dbconfig[mode]["host"]
    dbopts[:user] = dbconfig[mode]["username"]
    dbopts[:password] = dbconfig[mode]["password"]
    dbopts[:database] = dbconfig[mode]["database"]
    dbopts[:encoding] = dbconfig[mode]["encoding"]
    Sequel.mysql2(nil, dbopts)
  end

  def self.s3
    
  end
end