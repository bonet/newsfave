module SessionsHelper
  
  def sign_in(user)
    session[:user_id] = user.id
  end
  
  def signed_in?
    (session.include? :user_id) && (session[:user_id].present?)
  end
  
  def deny_access
    redirect_to signin_path, :notice => "Please Sign In to access this page"
  end
  
  def deny_access_no_html
    return render :nothing => true 
  end
  
  def sign_out
    session[:user_id] = nil
  end
end
