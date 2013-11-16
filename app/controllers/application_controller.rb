class ApplicationController < ActionController::Base
  
  include ApplicationHelper
  
  before_filter :retrieve_default_categories_per_publisher
  
  protect_from_forgery
  
  # set_cache_buster: To prevent browser caching (when clicking 'previous' button).  Browser caching causes 
  # logged-out user to still be able to see their logged-in-only info when they go back to the previous page
  
  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
  
end
