class UsersController < ApplicationController
  
  before_filter :session_authenticate, :only => [:edit, :show, :update, :update_pub_cats, :feed_subscribe]
  
  before_filter :params_check, :only => [:feed_subscribe]
  
  def new
    @user = User.new
    @title = "Sign Up"
  end
  
  
  def show
    unless signed_in? #sessions_helper
      redirect_to signin_path
    end
    
    @user = User.find(session[:user_id])
    @title = @user.username
    
    @pub_cat_json = ""
    
    unless(@user.pub_cat_aggregate_id.nil?)
      
      result = Curl.get(Silverstar::Application.config.feed_webservice_url + "/get_personalized_pub_cat_namelist/" + @user.pub_cat_aggregate_id.to_s)
      @pub_cat_namelist_json = JSON.parse(result.body_str) unless result.body_str == "null"
    end
    
    @namelist_hash = {}
    
    @pub_cat_namelist_json.each do |k,v| 
      v['categories'].each do |m|
        if m['owned'] == "true"
          if @namelist_hash[v['publisher_name']].nil?
            @namelist_hash[v['publisher_name']] = []
          end
          
          @namelist_hash[v['publisher_name']] << m['category_name']
        end
      end
    end
    
  end
  
  
  def create
    @user = User.new(params[:user])

    if @user.save
      
      sign_in @user   #sessions_helper
      render :json => { :username => @user.username }
      
    else
      render :json => { :errors => @user.errors.full_messages }, :status => 422
    end
  end
  
  
  def edit
    @user = User.find(session[:user_id])
    render 'edit'
  end
  
  
  def update_pub_cats
    @user = User.find(session[:user_id])
  end
  
  
  
  def update
    @user = User.find(session[:user_id])
    
    param_hash = { :username => params[:user][:username], :email => params[:user][:email] }

    #only update avatar if the avatar file is present
    if params[:user][:avatar].present? 
      param_hash[:avatar] = params[:user][:avatar]
    end
    
    #only update password if password field is present
    if params[:user][:password].present? 
      param_hash[:password] = params[:user][:password]
    end
    
    if @user.update_attributes(param_hash)
      
      flash[:success] = "Profile Updated"
      redirect_to @user
    else
      render 'edit'
    end
    
  end
  
  
  def feed_subscribe
    
    result = Curl::Easy.http_post(Silverstar::Application.config.feed_webservice_url + "/register_pub_cats/", 
                         Curl::PostField.content('pub_cat_ids', params['pub_cat_ids']))
    pca = JSON.parse(result.body_str)
    
    unless pca['_id'].nil?
      @user = User.find(session[:user_id])
      @user.pub_cat_aggregate_id = pca['_id'];
      @user.save
    end
    
    render :text => { "pub_cat_aggregate_id" => pca['_id'].to_s }.to_json
    
  end
  
  private
    
    def session_authenticate
      self.set_cache_buster # ApplicationController method
      deny_access unless signed_in? #sessions_helper
    end
    
    def session_authenticate_no_html
      self.set_cache_buster # ApplicationController method
      deny_access_no_html unless signed_in? #sessions_helper
    end
    
    def params_check
      return render :nothing => true if params['pub_cat_ids'].nil?
    end
    
end