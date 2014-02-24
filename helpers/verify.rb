module Verify
  def has_apikey(params)
    key = params[:apikey]
    name = params[:user_name]
    user = DB[:user].where(name: name).first
    
    if user.nil? then
      raise UserNotFound, "存在しないユーザです(#{name})"
    end
    
    collate = Crypt.make_apikey(user)

    if key != collate then
      raise InvalidAPIKey, "無効なAPIキーです"
    end
    true
  end
end