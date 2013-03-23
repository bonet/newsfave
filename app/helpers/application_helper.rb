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
    image_tag("logo-14.png", :alt => 'NewsFave Logo', :class => "")
  end
end
