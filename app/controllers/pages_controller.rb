class PagesController < ApplicationController
  def home
    @title = "Home"
    
    result = Curl.get(Silverstar::Application.config.feed_webservice_url + "/get_default_pub_cat_aggregate/")
                         #, Curl::PostField.content('thing[name]', 'box'),
                         #Curl::PostField.content('thing[type]', 'storage'))
    result_json = JSON.parse(result.body_str)
    @categories_json = result_json['pub_cat_aggregate_categories']
    @publishers_json = result_json['pub_cat_aggregate_publishers']

  end

  def feedlist
    @title = "Feed List"
  end
end
