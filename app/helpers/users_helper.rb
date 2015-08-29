module UsersHelper

  # Returns the Gravatar image for a specified email address.
  # For more info, see http://en.gravatar.com/site/implement/images/
  def gravatar_for(user)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt:user.name, class:"gravatar")
  end

end
