module SessionsHelper

  # Logs-in the specified user.
  # Uses the built-in Rails method 'session', which
  #   stores a temporary and encrypted cookie on the
  #   client browser.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Checks if the session has a logged-in user.
  def logged_in?
    !current_user.nil?
  end

  # Logs-out the current user.
  # Removes the session data from the client browser.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Returns the currently logged-in user.
  # It first checks if the session already has a logged_in user.
  #   If it does, this method will use the saved user_id. The
  #   first pass retrieves the user from the database and
  #   stores it in an instance variable. Subsequent calls to
  #   this method simply returns the instance variable.
  # If the session does not have a user, it then checks if the
  #   cookies has a persistent user. If it does, this method
  #   will then try to authenticate the persistent user. Once
  #   authenticated, the persistent user is logged-in and is
  #   returned.
  # If the session or the cookies does not have a user, this
  #   method returns nil.
  # Note that 'find_by' is used here instead of 'find'.
  #   This is because 'find_by' raises an exception if
  #   the id is non-existent, while 'find' returns nil.
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id:user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in(user)
        @current_user = user
      end
    end
  end

  # Returns true if the specified user is the currently
  #  logged-in user. Returns false otherwise.
  def current_user?(user)
    user == current_user
  end

  # Remembers the logged-in user using a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id  # encrypt the user_id instead of plaintext
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Reverses the remember method.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Remembers the URL being accessed.
  def store_location
    session[:forward_url] = request.url if request.get?
  end

  # Redirects to the stored forward URL.
  # If no forward URL is defined, redirects
  #  to the specified default instead.
  def redirect_to_stored_location_or(default)
    redirect_to(session[:forward_url] || default)
    session.delete(:forward_url)
  end

end
