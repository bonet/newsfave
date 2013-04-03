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
  
  def valid_json? json_  
    JSON.parse(json_)  
    return true  
  rescue JSON::ParserError  
    return false  
  end 
end
