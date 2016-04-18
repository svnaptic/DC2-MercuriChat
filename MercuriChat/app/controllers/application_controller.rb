
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Referenced from: http://stackoverflow.com/questions/23555618/redirect-to-log-in-page-if-user-is-not-authenticated-with-devise
  #protected
  #def authenticate_user!
  #	if logged_in?
  #		redirect_to dashboard
  #	else
  #		redirect_to sign_in_path
  #end
  #end

  # Referenced from: https://www.railstutorial.org/book/log_in_log_out
  include UsersHelper
end
