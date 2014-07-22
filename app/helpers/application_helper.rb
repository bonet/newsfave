module ApplicationHelper
  
  def title
    base_title  = "NewsFave"
    
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  def logo
    image_tag("logo-1.png", :alt => 'NewsFave Logo', :class => "")
  end
  
  def retrieve_default_categories_per_publisher
    if signed_in? == false
      result = Curl.get(Rails.configuration.api_location_get_default_categories_per_publisher)
      @default_categories_per_publisher = (result.response_code == 200) ? JSON.parse(result.body_str) : nil
    end
  end
end
