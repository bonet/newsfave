class UsersController < ApplicationController

  before_filter :retrieve_user, :only => :show
  
  def show
    
    if(signed_in?)
      categories_per_publisher_json = @user.retrieve_categories_per_publisher_json
    else
      categories_per_publisher_json = User.get_categories_per_publisher_json
    end
   
    @categories_per_publisher_hash = {}
    
    categories_per_publisher_json.each do |k,v| 
      v['categories'].each do |m|
        if m['owned'] == "true"
          if @categories_per_publisher_hash[v['publisher_name']].nil?
            @categories_per_publisher_hash[v['publisher_name']] = []
          end
          
          @categories_per_publisher_hash[v['publisher_name']] << m['category_name']
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