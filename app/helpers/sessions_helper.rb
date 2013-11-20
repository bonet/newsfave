module SessionsHelper
  
  def signed_in?
    (session.include? :user_id) && (session[:user_id].present?)
  end
  
end
