ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # To prevent conflict with application methods, all test_helper methods
  # should be prepended by 'check_' (note that 'test_' cannot be used here
  # since Rails automatically names all test cases with 'test_').

  # Returns true if a user is logged-in, false otherwise.
  def check_logged_in?
    !session[:user_id].nil?
  end

end
