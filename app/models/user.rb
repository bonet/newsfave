class User < ActiveRecord::Base
  
  #require 'paperclip'

  devise :database_authenticatable, :registerable, :validatable
  
  attr_accessible :username, :email, :password, :password_confirmation

  
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

end
