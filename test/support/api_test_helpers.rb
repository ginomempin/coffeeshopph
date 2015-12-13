module APITestHelpers

  def parse_json_from(response)
    begin
      JSON.parse(response.body, symbolize_names: true)
    rescue JSON::ParserError => e
      {}
    end
  end

  # Checks if an array of error messages contains the
  # specified message. Searching is case-insensitive.
  def has_error_message(errors, message)
    errors.any? { |error| error.downcase.include?(message.downcase) }
  end

end
