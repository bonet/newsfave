class User < ActiveRecord::Base
  
  require 'paperclip'

  #attr
  attr_accessor :password # virtual attribute (a.k.a not in the database).  User class already has :email and :password attributes -> from Users db table columns

  attr_accessible :email, :username, :password, :password_confirmation, :avatar # for "new User(params_array)" (a.k.a mass assignment)
  
  #validation
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :username, :presence => true,
                       :length => { :maximum => 20 },
                       :uniqueness => { :case_sensitive => false }
                   
  validates :email, :presence => true,
                    :format => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
                    
  validates :password, :presence => { :if =>  :new_user_or_password_parameter_exists? }, 
                       :confirmation => { :if =>  :new_user_or_password_parameter_exists? },  # automatically creates ':password_confirmation' virtual attribute
                       :length => { :if =>  :new_user_or_password_parameter_exists?, :within => 6..40 }
  
  
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
  
  before_save :encrypt_password, :if => :new_user_or_password_parameter_exists?
  
  
  #Email - Password Authentication
  def self.authenticate(email, submitted_password)
    user = find_by(email: email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

=begin
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
=end
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
      
  protected
  
    def new_user_or_password_parameter_exists?
      self.new_record? || self.password.present?
    end
    
    def new_user_or_avatar_parameter_exists?
      self.new_record? || self.avatar.present?
    end
    
  private
  
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end
    
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
