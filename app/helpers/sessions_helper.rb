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
    session.delete(:user_id)
    @current_user = nil
  end

  # Returns the currently logged-in user.
  # The first pass retrieves the user from the database and
  #   stores it in an instance variable. Subsequent calls to
  #   this method simply returns the instance variable.
  # If no user is logged-in (session[:user_id] is nil), then
  #   this method returns nil.
  # Note that 'find_by' is used here instead of 'find'.
  #   This is because 'find_by' raises an exception if
  #   the id is non-existent, while 'find' returns nil.
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

end
