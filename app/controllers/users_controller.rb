class UsersController < ApplicationController

  before_filter :retrieve_user, :only => :show
  
  def show
    @pub_cat_json = ""
    
    @api_location = @user.pub_cat_aggregate_id.present? ? Rails.configuration.api_location_get_personalized_newsfeed_aggregate + @user.pub_cat_aggregate_id.to_s : Rails.configuration.api_location_get_default_newsfeed_aggregate

    result = Curl.get(@api_location)
    @pub_cat_namelist_json = JSON.parse(result.body_str) unless result.body_str == "null"

    @namelist_hash = {}
    
    @pub_cat_namelist_json.each do |k,v| 
      v['categories'].each do |m|
        if m['owned'] == "true"
          if @namelist_hash[v['publisher_name']].nil?
            @namelist_hash[v['publisher_name']] = []
          end
          
          @namelist_hash[v['publisher_name']] << m['category_name']
        end
      end
    end
    
  end

  

  
  
  private
    
  def retrieve_user
    begin
      @user = User.find(session[:user_id])
      @title = @user.username
    rescue
      redirect_to new_user_session_path
      return
    end
  end
    
end