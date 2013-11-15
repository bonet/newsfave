class SessionsController < Devise::SessionsController
  
  after_filter :populate_session, :only => :create
  
  def new
    @title = "Sign In"
    render "users/sessions/new"
  end
  
  
  def create
    # taken from https://github.com/plataformatec/devise/blob/master/app/controllers/devise/sessions_controller.rb
    
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource)     # BSMOD_11142013: this is modified from the original code to include only 1 parameter (resource)
    
    yield resource if block_given?
    redirect_to root_path
  end
  
  
  def destroy
    super
    session[:user_id] = nil
  end
  
  
  private
  
  def populate_session
    session[:user_id] = @user.id
  end
end
