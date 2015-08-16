module ApplicationHelper

  # Returns the formatted tab title.
  # If a specific title is provided, it will be appended to the default tab title.
  def format_tab_title(tab_title='')
    if tab_title.empty?
      APP_NAME
    else
      APP_NAME + " | " + tab_title
    end
  end

  # Returns the formatted page header.
  # If a specific header is provided, that will be used instead.
  def format_page_header(page_header='')
    if page_header.empty?
      APP_NAME
    else
      page_header
    end
  end

end
