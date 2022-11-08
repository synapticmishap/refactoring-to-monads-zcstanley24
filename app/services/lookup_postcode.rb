class LookupPostcode
  def call(postcode)
    response = Rails.configuration.api.get("/addresses/#{postcode}")
    JSON.parse(response.body).fetch('addresses')
  rescue Faraday::Error, JSON::ParserError
    []
  end
end

