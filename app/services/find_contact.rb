class FindContact
  def call(id)
    response = Rails.configuration.api.get("/contacts/#{id}")
    JSON.parse(response.body).fetch('contact')
  rescue Faraday::Error, JSON::ParserError
    nil
  end
end
