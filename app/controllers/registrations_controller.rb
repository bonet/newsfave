class RegistrationsController < Devise::RegistrationsController
  
  before_filter :params_check, :only => [:feed_subscribe]
  after_filter :populate_session, :only => :create
  
  def new
    @title = "Sign Up"
    render "users/registrations/new"
  end


  def create
    begin
      @user = User.new(params[:user]) 
      if @user.save
        render :json => { :username => @user.username }
      else
        render :json => { :errors => @user.errors.full_messages }, :status => 422
      end
    rescue Exception => e  
      render :json => { :errors => e.message }, :status => 422
    end
  end


  def update
    @user = User.find(session[:user_id])

    if params[:edit_info].present? && (!params[:user][:password].blank?) && (params[:user][:password] == params[:user][:password_confirmation])
      @user.password = params[:user][:password] 
      @user.save
    end
    
    render 'edit'
  end
  
  
  def update_pub_cats
    @user = User.find(session[:user_id])
  end
  
  
  def feed_subscribe
    
    result = Curl::Easy.http_post(Rails.configuration.feed_webservice_url + "/register_pub_cats/", 
                                  Curl::PostField.content('pub_cat_ids', params['pub_cat_ids']))
    pca = JSON.parse(result.body_str)
    
    unless pca['_id'].nil?
      @user = User.find(session[:user_id])
      @user.pub_cat_aggregate_id = pca['_id'];
      @user.save
    end
    
    render :text => { "pub_cat_aggregate_id" => pca['_id'].to_s }.to_json
    
  end
  
  
  def edit
    @user = User.find(session[:user_id])
    render 'edit'
  end
  
  
  private
  
  def params_check
    return render :nothing => true if params['pub_cat_ids'].nil?
  end
  
  def populate_session
    session[:user_id] = @user.id
  end
  
end