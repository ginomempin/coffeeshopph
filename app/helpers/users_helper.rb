module UsersHelper

  # Returns the Gravatar image for a specified email address.
  # For more info, see http://en.gravatar.com/site/implement/images/
  def gravatar_for(user, options = { size:80 })
    id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    url = "https://secure.gravatar.com/avatar/#{id}?s=#{size}"
    image_tag(url, alt:user.name, class: "gravatar")
  end

end
