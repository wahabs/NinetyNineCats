class ApplicationController < ActionController::Base
  helper_method :current_user
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    return nil if session[:session_token].nil?
    @current_user ||= begin
      sess = Session.find_by_token(session[:session_token])
      sess ? sess.user : nil
      # if sess
      #   sess.user
      # else
      #   nil
      # end
    end
  end

  def log_in!(user)
    new_session = Session.create!(token: SecureRandom::urlsafe_base64, user_id: user.id)
    session[:session_token] = new_session.token
  end

  def log_out!
    Session.find_by_token(session[:session_token]).destroy
    session[:session_token] = nil
  end

  def redirect_if_logged_in
    redirect_to cats_url unless current_user.nil?
  end

end
