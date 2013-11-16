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


  def edit
    @user = User.find(session[:user_id])
    @categories_per_publisher_json = @user.retrieve_categories_per_publisher_json
    
    render 'users/registrations/edit'
  end
  
  
  def update
    @user = User.find(session[:user_id])
    
    if (!params[:user][:password].blank?) && (params[:user][:password] == params[:user][:password_confirmation])
      @user.password = params[:user][:password] 
      @user.save!
    end
    
    redirect_to edit_user_registration_path
  end

  
  def update_newsfeeds
    @user = User.find(session[:user_id])
  end
  
  
  def feed_subscribe
    @user = User.find(session[:user_id])
    @user.subscribe_to_newsfeeds(param['newsfeed_ids'])
    
    render :text => { "newsfeed_aggregate_id" => @user.newsfeed_aggregate_id.to_s }.to_json
  end
  
  
  private
  
  def params_check
    return render :nothing => true if params['newsfeed_ids'].nil?
  end
  
  def populate_session
    session[:user_id] = @user.id
  end
  
end