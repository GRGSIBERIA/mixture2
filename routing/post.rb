#-*- encoding: utf-8
require 'base64'

def file_name_hash(request)
  Digest::SHA256.hexdigest(request.ip.to_s + Time.now.to_s)
end

def host_url
  'http://localhost:3000'
end

def redirect_url(host_url, user_name)
  "#{host_url}/post/done/#{user_name}"
end

def routing_post
  get '/post/done/:user_id' do 
    file_hash = File.basename(params[:key], ".*")
    extension = File.extname(params[:key])
    user_id = params[:user_id].to_i

    Post.create(user_id, file_hash, extension)
    "succeeded #{file_hash}"
  end

  get '/post/new/:user_id' do 
    @access_key = MIXTURE_FREE_ACCESS_KEY
    @fname_hash = file_name_hash(request)
    @policy = s3_policy(redirect_url(host_url, params[:user_id]))
    @signature = s3_signature(@policy)
    @redirect = host_url

    @user_id = params[:user_id].to_i
    if User.find(id: @user_id).nil? then
      halt 400, "user_id(#{@user_id}) is not found."
    end
    slim :new_post
  end

  get '/post/prepare/:user_id' do 
    user_id = params[:user_id].to_i
    user = User.find(id: user_id)
    @render = ""
    if user.nil? then
      halt 400, "user_id(#{user_id}) is not found."
    else
      file_hash = file_name_hash(request)
      buf_policy = s3_policy(redirect_url(host_url, user.id))
      @render = {
        policy:     buf_policy,
        signature:  s3_signature(buf_policy),
        access_key: MIXTURE_FREE_ACCESS_KEY,
        fname_hash: file_hash,
        host:       host_url
      }.to_json
    end
    slim :render_simple
  end

  # base64を受け取って直接S3へアップロードする
  post '/post/direct' do
    begin
      user_id = params[:user_id].to_i
      data = Base64.decode64(params[:data])
      extension = params[:extension]
      content_type = params[:content_type]
      file_name_hash = file_name_hash(request)
      params[:tags] ||= ""
      tags = params[:tags].downcase.sub(" ","").split(',')

      bucket = Connector.s3_bucket
      object = bucket.objects["uploads/#{file_name_hash}#{extension}"]
      object.write(data, content_type: content_type)

      Post.create(user_id, file_name_hash, extension)
      tags.each do |tag| 
        Tag.find_create(tag)
      end
    rescue => e
      raise_helper(e, params)
    end
    "success"
  end
end