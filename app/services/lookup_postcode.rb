class LookupPostcode
  include Dry::Monads[:result]

  def call(postcode)
    response = Rails.configuration.api.get("/addresses/#{postcode}")
    Success(JSON.parse(response.body).fetch('addresses'))
  rescue Faraday::Error, JSON::ParserError => error
    Failure(error)
  end
end
