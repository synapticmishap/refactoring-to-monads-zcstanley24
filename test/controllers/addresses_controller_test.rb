class AddressesControllerTest < ActionDispatch::IntegrationTest
  include WebMock::API

  test 'should show address dropdown when all requests are successful' do
    simulate_contacts_api_returning(contact: { postcode: 'AB123DE' })
    simulate_postcode_lookup_api_returning(addresses: ['1 Main Street', '2 Main Street', '5 Old Street'])

    get '/addresses/edit?contact_id=123'
    assert_response :success
    assert_select 'select' do
      assert_select 'option', 3
    end
  end

  test 'should show error when finding contact times out' do
    simulate_contacts_api_timing_out

    get '/addresses/edit?contact_id=123'
    assert_response :success
    assert_select 'p', 'Something went wrong. Please try again.'
  end

  test 'should show error when api returns invalid JSON' do
    simulate_contacts_api_returning_body('{ "broken": "json')

    get '/addresses/edit?contact_id=123'
    assert_response :success
    assert_select 'p', 'Something went wrong. Please try again.'
  end


  test 'should show error when finding contact returns a 404' do
    simulate_contacts_api_returning_status_code(404)

    get '/addresses/edit?contact_id=123'
    assert_response :success
    assert_select 'p', 'Something went wrong. Please try again.'
  end

  test 'should show error when finding contact returns internal server error' do
    simulate_contacts_api_returning_status_code(500)

    get '/addresses/edit?contact_id=123'
    assert_response :success
    assert_select 'p', 'Something went wrong. Please try again.'
  end

  test 'shows manual address lookup when the postcode lookup times out' do
    simulate_contacts_api_returning(contact: { postcode: 'AB123DE' })
    simulate_postcode_lookup_api_timing_out

    get '/addresses/edit?contact_id=123'
    assert_response :success
    assert_select 'input#street'
    assert_select 'input#city'
    assert_select 'input#state'
    assert_select 'input#postcode'
  end

  test 'shows manual address lookup when the postcode lookup gives a 404' do
    simulate_contacts_api_returning(contact: { postcode: 'AB123DE' })
    simulate_postcode_lookup_api_returning_status_code(404)

    get '/addresses/edit?contact_id=123'
    assert_response :success
    assert_select 'input#street'
    assert_select 'input#city'
    assert_select 'input#state'
    assert_select 'input#postcode'
  end

  test 'shows manual address lookup when the postcode lookup returns an internal server error' do
    simulate_contacts_api_returning(contact: { postcode: 'AB123DE' })
    simulate_postcode_lookup_api_returning_status_code(500)

    get '/addresses/edit?contact_id=123'
    assert_response :success
    assert_select 'input#street'
    assert_select 'input#city'
    assert_select 'input#state'
    assert_select 'input#postcode'
  end

  test 'shows manual address lookup when the postcode lookup returns invalid json' do
    simulate_contacts_api_returning(contact: { postcode: 'AB123DE' })
    simulate_postcode_lookup_api_returning_body('{"broken": "json')

    get '/addresses/edit?contact_id=123'
    assert_response :success
    assert_select 'input#street'
    assert_select 'input#city'
    assert_select 'input#state'
    assert_select 'input#postcode'
  end

  def setup
    WebMock.enable!
    super
  end

  def teardown
    super
    WebMock.disable!
  end

  private

  def simulate_contacts_api_timing_out
    stub_request(:get, 'https://private-f59e7-usingmonadsforeleganterrorhandling.apiary-mock.com/contacts/123')
      .to_timeout
  end

  def simulate_contacts_api_returning(data)
    simulate_contacts_api_returning_body(JSON.generate(data))
  end

  def simulate_contacts_api_returning_body(body)
    stub_request(:get, 'https://private-f59e7-usingmonadsforeleganterrorhandling.apiary-mock.com/contacts/123')
      .to_return(status: 200, body: body)
  end

  def simulate_contacts_api_returning_status_code(status_code)
    stub_request(:get, 'https://private-f59e7-usingmonadsforeleganterrorhandling.apiary-mock.com/contacts/123')
      .to_return(status: status_code, body: JSON.generate({}))
  end

  def simulate_postcode_lookup_api_timing_out
    stub_request(:get, 'https://private-f59e7-usingmonadsforeleganterrorhandling.apiary-mock.com/addresses/AB123DE')
      .to_timeout
  end

  def simulate_postcode_lookup_api_returning_body(body)
    stub_request(:get, 'https://private-f59e7-usingmonadsforeleganterrorhandling.apiary-mock.com/addresses/AB123DE')
      .to_return(status: 200, body: body)
  end

  def simulate_postcode_lookup_api_returning(data)
    simulate_postcode_lookup_api_returning_body(JSON.generate(data))
  end

  def simulate_postcode_lookup_api_returning_status_code(status_code)
    stub_request(:get, 'https://private-f59e7-usingmonadsforeleganterrorhandling.apiary-mock.com/addresses/AB123DE')
      .to_return(status: status_code, body: JSON.generate({}))
  end
end
