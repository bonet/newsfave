class UsersController < ApplicationController

  before_action :retrieve_user, :only => :show
  
  def show
    
    @pub_cat_json = ""
    
    @api_string = "/get_pub_cat_namelist"
    
    if @user.pub_cat_aggregate_id.present?
      @api_string = "/get_personalized_pub_cat_namelist/" + @user.pub_cat_aggregate_id.to_s
    end

    result = Curl.get(Rails.configuration.feed_webservice_url + @api_string)
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
    
    def session_authenticate
      self.set_cache_buster # ApplicationController method
      deny_access unless signed_in? #sessions_helper
    end
    
    def session_authenticate_no_html
      self.set_cache_buster # ApplicationController method
      deny_access_no_html unless signed_in? #sessions_helper
    end
    
    def params_check
      return render :nothing => true if params['pub_cat_ids'].nil?
    end
    
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