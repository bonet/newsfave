class User < ActiveRecord::Base
  
  #require 'paperclip'

  devise :database_authenticatable, :registerable, :validatable
  
  attr_accessible :username, :email, :password, :password_confirmation

  attr_reader :newsfeed_aggregate_id
  
=begin
  #Paperclip Stuff
  has_attached_file :avatar, :path           => '/images/:id/:style.:extension',
                                :storage        => :s3,
                                :url            => ':s3_domain_url',
                                :s3_host_alias  => ENV['S3_HOST'],
                                :s3_credentials => { 
                                                     :bucket => ENV['AWS_BUCKET'],
                                                     :access_key_id => ENV['AWS_ACCESS_KEY_ID'],                   
                                                     :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'] 
                                                     },
                                :styles         => {
                                                     #:original => ['1920x1680>', :jpg],
                                                     :small    => ['100x100#',   :jpg],
                                                     #:medium   => ['250x250',    :jpg],
                                                     #:large    => ['500x500>',   :jpg]
                                                     }
                             
  validates_attachment :avatar, :presence => { :if =>  :new_user_or_avatar_parameter_exists? },
                                :size => { :if =>  :new_user_or_avatar_parameter_exists?, :less_than => 5.megabytes },
                                :content_type => { :if =>  :new_user_or_avatar_parameter_exists?, :content_type => ['image/jpeg', 'image/png'] }

  #Paperclip Stuff Ends
=end


  def self.get_newsfeed_aggregate_json
    result = Curl.get(Rails.configuration.api_location_get_default_newsfeed_aggregate)
    result_json = result.body_str == "null" ? "" : JSON.parse(result.body_str)
  end
  
  
  def retrieve_newsfeed_aggregate_json
    
    newsfeed_aggregate_json = ""
    
    if self.newsfeed_aggregate_id.blank? == false
      # get personalized
      result = Curl.get(Rails.configuration.api_location_get_personalized_newsfeed_aggregate + self.newsfeed_aggregate_id.to_s)
      newsfeed_aggregate_json = result.body_str == "null" ? "" : JSON.parse(result.body_str)
    end
    
    if newsfeed_aggregate_json.blank?
      # get default
      result = Curl.get(Rails.configuration.api_location_get_default_newsfeed_aggregate)
      newsfeed_aggregate_json = JSON.parse(result.body_str)
    end   
    
    newsfeed_aggregate_json
  end
  
  
  def retrieve_categories_per_publisher_json
    api_location = self.newsfeed_aggregate_id.present? ? Rails.configuration.api_location_get_personalized_newsfeed_aggregate + self.newsfeed_aggregate_id.to_s : Rails.configuration.api_location_get_default_newsfeed_aggregate
    
    result = Curl.get(api_location)
    newsfeed_aggregate_json = result.body_str == "null" ? "" : JSON.parse(result.body_str)
  end 
  
  
  def subscribe_to_newsfeeds(newsfeed_ids)
    result = Curl::Easy.http_post(Rails.configuration.api_location_create_personalized_newsfeed_aggregate, 
                                  Curl::PostField.content('newsfeed_ids', newsfeed_ids))
    newsfeed_aggregate = JSON.parse(result.body_str)
    
    unless newsfeed_aggregate['_id'].nil?
      self.newsfeed_aggregate_id = newsfeed_aggregate['_id']
      self.save
    end
  end

end
