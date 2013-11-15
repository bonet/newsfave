module SessionsHelper
  
  def signed_in?
    (session.include? :user_id) && (session[:user_id].present?)
  end
  
  def deny_access
    redirect_to new_user_session_path, :notice => "Please Sign In to access this page"
  end
  
  def deny_access_no_html
    return render :nothing => true 
  end
  
end
