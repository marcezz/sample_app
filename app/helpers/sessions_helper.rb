module SessionsHelper
	def sign_in(user)
		remember_token = User.new_remember_token
		cookies.permanent[:remember_token] = remember_token
		user.update_attribute(:remember_token, User.digest(remember_token))
		self.current_user = user

	# Here we follow the desired steps: 
	# first, create a new token;
	# second, place the raw token in the browser cookies;
	# third, save the hashed token to the database;
	# fourth, set the current user equal to the given user (Section 8.2.3).

	end

	def signed_in?
		!current_user.nil? 		# "!" = "not" in Ruby
  	end

	def current_user=(user)
		@current_user = user
	end


	def current_user
    remember_token = User.digest(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
    		# calls the find_by method the first time current_user is called,
    		# but on subsequent invocations returns @current_user without hitting the database.
  	end
  	
  	def current_user?(user)
    	user == current_user
  	end
  	
  	def sign_out
    	current_user.update_attribute(:remember_token,
                                  User.digest(User.new_remember_token))
    	cookies.delete(:remember_token)
    	self.current_user = nil
  	end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end
  	
end
