module ApplicationHelper

  # Returns the default page title.
  # If a specific title is provided, it will be appended to the default page title.
  def default_page_title(page_title='')
    if page_title.empty?
      APP_NAME
    else
      APP_NAME + " | " + page_title
    end
  end

  # Returns the default page header.
  # If a specific header is provided, that will be used instead.
  def default_page_header(page_header='')
    if page_header.empty?
      APP_NAME
    else
      page_header
    end
  end

end
