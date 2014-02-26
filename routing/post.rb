#-*- encoding: utf-8

def routing_post
  get '/post/new' do 
    policy_document = <<EOS
{"expiration": "2113-08-17T00:00:00Z",
  "conditions": [
    {"bucket": "mixture-posts"},
    ["starts-with", "$key", "uploads/"],
    {"acl": "private"},
    {"success_action_redirect": "http://localhost:3000/"},
    ["starts-with", "$Content-Type", ""],
    ["content-length-range", 0, 1073741824]
  ]
}
EOS
 
    @policy = Base64.encode64(policy_document).gsub("\n","")
     
    aws_secret_key = MIXTURE_FREE_SECRET_KEY
    @signature = Base64.encode64(
        OpenSSL::HMAC.digest(
            OpenSSL::Digest::Digest.new('sha1'),
            aws_secret_key, @policy)
        ).gsub("\n","")

    @access_key = MIXTURE_FREE_ACCESS_KEY
     
    slim :new_post
  end
end