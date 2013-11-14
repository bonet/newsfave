class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  
  before_filter :get_pub_cat_namelist
  
  
  # set_cache_buster: To prevent browser caching (when clicking 'previous' button).  Browser caching causes 
  # logged-out user to still be able to see their logged-in-only info when they go back to the previous page
  
  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
  
  
  def get_pub_cat_namelist
    if signed_in? == false || ( params['controller'] == "users" && ( params['action'] == "edit" || 
                                params['action'] == "update" || params['action'] == "show") )
      result = Curl.get(Rails.configuration.feed_webservice_url + "/get_pub_cat_namelist/")
      @pub_cat_namelist = JSON.parse(result.body_str)
    end
  end
  
end
