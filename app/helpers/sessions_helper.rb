module SessionsHelper
  def login(user)
    session[:user_id] = user.id
    current_user
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logout
    @current_user = nil
    session.delete(:user_id)
  end

  def is_logged_in?
    current_user.present?
  end
end