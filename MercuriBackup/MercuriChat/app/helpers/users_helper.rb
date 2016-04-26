module UsersHelper
	# Referenced from: https://www.railstutorial.org/book/log_in_log_out
	# Logging into the given user:
	def log_in(user)
		session[:user_id] = user.id
	end

	# Finding current users in session:
	def current_user
		@current_user ||= User.find_by(id: session[:user_id])
	end

	# Returns true if a user is logged in:
	def logged_in?
		!current_user.nil?
	end
end
