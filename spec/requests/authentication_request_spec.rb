require 'rails_helper'

RSpec.describe 'Authentication Requests', type: :request do
  after(:all) do
    Contact.destroy_all
    User.destroy_all
  end

  it 'allow access for user' do
    user = create(:user)
    @headers = login_headers(user.email)
    params = contact_creation_params
    post '/contacts', params, @headers
    expect(response).to have_http_status(200)
  end

  it 'deny access for invalid user' do
    user = create(:user)
    @headers = login_headers(Faker::Internet.email)
    params = contact_creation_params
    post '/contacts', params, @headers
    expect(response).to have_http_status(401)
  end

  it 'deny access for incorrect password' do
    user = create(:user)
    @headers = login_headers(user.email, Faker::Lorem.characters(4))
    params = contact_creation_params
    post '/contacts', params, @headers
    expect(response).to have_http_status(401)
  end
end
