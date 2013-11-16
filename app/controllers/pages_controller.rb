class PagesController < ApplicationController
  
  def home
    @title = 'Home'
    @result_json = ''
    
    if(signed_in?)
      @user = User.find(session[:user_id])
      @result_json = @user.retrieve_newsfeed_aggregate_json
    else
      @result_json = User.get_newsfeed_aggregate_json
    end
  end


  def feedlist
    @title = 'Feed List'
  end

end
