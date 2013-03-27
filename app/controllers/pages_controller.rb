class PagesController < ApplicationController
  def home
    @title = "Home"
    
    result_json = ""
    
    if(signed_in?)
      @user = User.find(session[:user_id])
      
      result = Curl.get(Silverstar::Application.config.feed_webservice_url + "/get_personalized_pub_cat_aggregate/" + @user.pub_cat_aggregate_id.to_s)
      result_json = JSON.parse(result.body_str) unless result.body_str == "null"
    end
    
    if result_json.empty?
      result = Curl.get(Silverstar::Application.config.feed_webservice_url + "/get_default_pub_cat_aggregate/")
      result_json = JSON.parse(result.body_str)
    end 

    @categories_json = result_json['pub_cat_aggregate_categories']
    @publishers_json = result_json['pub_cat_aggregate_publishers']

  end

  def feedlist
    @title = "Feed List"
  end
end
