#-*- encoding: utf-8
require 'aws-sdk'

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

  def self.s3_bucket
    s3 = AWS::S3.new(
      :access_key_id => MIXTURE_FREE_ACCESS_KEY,
      :secret_access_key => MIXTURE_FREE_SECRET_KEY)
    s3.buckets['mixture-posts']
  end
end

def s3_policy(redirect_url)
  # 3時間以内にアップロード
  policy_document = <<EOS
{"expiration": "2113-08-17T00:00:00Z",
  "conditions": [
    {"bucket": "mixture-posts"},
    ["starts-with", "$key", "uploads/"],
    {"acl": "public-read"},
    {"success_action_redirect": "#{redirect_url}"},
    ["starts-with", "$Content-Type", ""],
    ["content-length-range", 0, 1073741824]
  ]
}
EOS
 
  Base64.encode64(policy_document).gsub("\n","")
end

def s3_signature(policy)
  aws_secret_key = MIXTURE_FREE_SECRET_KEY
  Base64.encode64(
    OpenSSL::HMAC.digest(
      OpenSSL::Digest::Digest.new('sha1'),
      aws_secret_key, policy)
    ).gsub("\n","")
end