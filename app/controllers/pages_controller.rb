class PagesController < ApplicationController
  def home
    @title = "Home"
    
    result = ""
    
    if(signed_in?)
      @user = User.find(session[:user_id])
      
      result = Curl.get(Silverstar::Application.config.feed_webservice_url + "/get_personalized_pub_cat_aggregate/" + @user.pub_cat_aggregate_id.inspect.to_s)
      result_json = JSON.parse(result.body_str)
    else
      result = Curl.get(Silverstar::Application.config.feed_webservice_url + "/get_default_pub_cat_aggregate/")
    end 

    result_json = JSON.parse(result.body_str)
    @categories_json = result_json['pub_cat_aggregate_categories']
    @publishers_json = result_json['pub_cat_aggregate_publishers']

  end

  def feedlist
    @title = "Feed List"
  end
end
