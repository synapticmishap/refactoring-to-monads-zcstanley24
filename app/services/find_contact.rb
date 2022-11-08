class FindContact
  include Dry::Monads[:result]

  def call(id)
    response = Rails.configuration.api.get("/contacts/#{id}")
    Success(JSON.parse(response.body).fetch('contact'))
  rescue Faraday::Error, JSON::ParserError => error
    Failure(error)
  end
end
