#-*- encoding: utf-8

module Validation
  def not_null(cname, attribute, key, params)
    if attribute[key].nil? then
      raise ArgumentError, "#{cname}の#{key.to_s}がnilです"
    end
  end

  def not_blank(cname, attribute, key, params)
    if attribute[key].empty? or attribute[key].nil? then
      raise ArgumentError, "#{cname}の#{key.to_s}が空です"
    end
  end

  def length(cname, attribute, key, params)
    if params.key?(:max) then
      if attribute[key].length > params[:max] then
        raise ArgumentError, "#{cname}の#{key.to_s}の長さが#{params[:max]}より大きいです(#{attribute[key]})"
      end
    end
    if params.key?(:min) then
      if attribute[key].length < params[:min] then
        raise ArgumentError, "#{cname}の#{key.to_s}の長さが#{params[:min]}より小さいです(#{attribute[key]})"
      end
    end
  end

  def prohibition_word(cname, attribute, key, params)
    proh = %w(index home top help about security contact connect support faq form mail update mobile phone portal tour tutorial navigation navi manual doc company store shop topic news information info howto pr press release sitemap plan price business premium member term privacy rule inquiry legal policy icon image img photo css stylesheet style script src js javascript dist asset source static file flash swf xml json sag cgi account user item entry article page archive tag category event contest word product project download video blog diary site popular i my me owner profile self old first last start end special design theme purpose book read organization community group all status state search explore share feature upload rss atom widget api wiki bookmark captcha comment jump ranking setting config tool connect notify recent report system sys message msg log analysis query call calendar friend graph watch cart activity auth session register login logout signup forgot admin root secure get show create edit update post destroy delete remove reset error new dashboard recruit join offer career corp cgi-bin server-status balancer-manager ldap-status server-info svn as by if is on or add dir off out put case else find then when count order select switch school developer dev test bug code guest app maintenance roc id bot game forum contribute usage feed ad service official language repository spec license asct dictionary dict version ver gift alpha beta tux year public private default request req data master die exit eval undef nan null empty 0 www)
    if proh.include?(attribute[key]) then
      raise ArgumentError, "#{cname}の#{key.to_s}が使用禁止の文字列を利用しています(#{attribute[key]})"
    end
  end

  def format(cname, attribute, key, params) 
    if params[:with].match(attribute[key]).nil? then
       raise ArgumentError, "#{cname}の#{key.to_s}がフォーマットに沿っていません(#{params[:with].to_s})"
    end
  end

  module_function :not_null
  module_function :not_blank
  module_function :length
  module_function :prohibition_word
  module_function :format
end