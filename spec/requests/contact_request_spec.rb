require 'rails_helper'

RSpec.describe 'Contact Requests', type: :request do

  after(:all) do
    Contact.destroy_all
    User.destroy_all
  end

  describe 'Contact creation' do
    before(:each) do
      @user = create(:user)
      @headers = login_headers(@user.email)
    end

    it 'create new contact' do
      params = contact_creation_params
      post '/contacts', params, @headers
      saved_contact = Contact.where(email: params[:email]).last
      expect(response).to have_http_status(200)
      expect(saved_contact).to be_present
      expect(saved_contact.name).to eq params[:name]
      expect(saved_contact.email).to eq params[:email]
      expect(saved_contact.user_id).to eq @user.id
    end

    it 'when email is already present' do
      params = contact_creation_params
      post '/contacts', params, @headers
      expect(response).to have_http_status(200)
      post '/contacts', params, @headers
      expect(response).to have_http_status(300)
      expect(hash_response[:errors][0]).to eq('email already exists')
    end

    it 'when name is not present' do
      params = contact_creation_params
      params.delete(:name)
      post '/contacts', params, @headers
      expect(response).to have_http_status(300)
      expect(hash_response[:errors][0]).to eq("name can't be blank")
    end

    it 'when email is not present' do
      params = contact_creation_params
      params.delete(:email)
      post '/contacts', params, @headers
      expect(response).to have_http_status(300)
      expect(hash_response[:errors][0]).to eq("email can't be blank")
    end
  end

  describe 'Contact updation' do
    before(:each) do
      @user = create(:user)
      @headers = login_headers(@user.email)
      @contact = create(:contact, user_id: @user.id)
    end

    it 'update contact' do
      params = contact_updation_params
      put "/contacts/#{@contact.id}", params, @headers
      expect(response).to have_http_status(200)
      @contact.reload
      expect(@contact).to be_present
      expect(@contact.name).to eq params[:name]
      expect(@contact.email).to eq params[:email]
    end

    it 'update invalid contact' do
      params = contact_updation_params
      put "/contacts/#{Faker::Lorem.characters(3)}", params, @headers
      expect(response).to have_http_status(404)
    end

    it 'forbid update for other users contact details' do
      second_user = create(:user)
      second_user_contact = create(:contact, user_id: second_user.id)
      params = contact_updation_params
      put "/contacts/#{second_user_contact.id}", params, @headers
      expect(response).to have_http_status(404)
    end
  end

  describe 'delete contact' do
    before(:each) do
      @user = create(:user)
      @headers = login_headers(@user.email)
      @contact = create(:contact, user_id: @user.id)
    end

    it 'delete contact' do
      delete "/contacts/#{@contact.id}", nil, @headers
      expect(response).to have_http_status(200)
      contact = @user.contacts.where(id: @contact.id)
      expect(contact).to_not be_present
    end

    it 'delete invalid contact' do
      delete "/contacts/#{Faker::Lorem.characters(3)}", nil, @headers
      expect(response).to have_http_status(404)
    end

    it 'forbid delete for other users contact details' do
      second_user = create(:user)
      second_user_contact = create(:contact, user_id: second_user.id)
      delete "/contacts/#{second_user_contact.id}", nil, @headers
      expect(response).to have_http_status(404)
    end
  end

  describe 'show contact' do
    before(:each) do
      @user = create(:user)
      @headers = login_headers(@user.email)
      @contact = create(:contact, user_id: @user.id)
    end

    it 'show contact' do
      get "/contacts/#{@contact.id}", nil, @headers
      expect(response).to have_http_status(200)
      expect(hash_response[:data][:attributes][:name]).to eq @contact.name
      expect(hash_response[:data][:attributes][:email]).to eq @contact.email
      expect(hash_response[:data][:attributes][:id]).to eq @contact.id
      expect(hash_response[:data][:attributes][:user_id]).to eq @contact.user_id
    end

    it 'show invalid contact' do
      get "/contacts/#{Faker::Lorem.characters(3)}", nil, @headers
      expect(response).to have_http_status(404)
    end

    it 'forbid show for other users contact details' do
      second_user = create(:user)
      second_user_contact = create(:contact, user_id: second_user.id)
      get "/contacts/#{second_user_contact.id}", nil, @headers
      expect(response).to have_http_status(404)
    end
  end

  describe 'show all contacts' do
    before(:each) do
      @user = create(:user)
      @headers = login_headers(@user.email)
      create(:contact, user_id: @user.id)
      create(:contact, user_id: @user.id)
    end

    it 'show all contact' do
      get '/contacts', nil, @headers
      expect(response).to have_http_status(200)
      contact_count = @user.contacts.count
      expect(hash_response[:data]).to be_present
      expect(hash_response[:data].length).to eq contact_count
    end
  end

  describe 'search contact' do
    before(:each) do
      @user = create(:user)
      @headers = login_headers(@user.email)
      create(:contact, user_id: @user.id)
      create(:contact, user_id: @user.id)
    end

    it 'show no result when query length is less than 1' do
      get '/contacts/search', contact_search_params(Faker::Lorem.characters(1), 1), @headers
      expect(response).to have_http_status(200)
      expect(hash_response[:data].length).to be 0
    end

    it 'searching with name' do
      20.times do |i|
        create(:contact_with_name, user_id: @user.id, name: "sample_contact_#{i}")
      end
      Contact.stub(:search) { @user.contacts.where("name like 'sample_contact_%'") }
      get '/contacts/search', contact_search_params(@user.contacts.first.name, 1), @headers
      expect(response).to have_http_status(200)
      expect(hash_response[:data].length).to be 10
    end

    it 'searching with email' do
      email = Faker::Lorem.characters(3)
      5.times do |i|
        create(:contact_with_email, user_id: @user.id, email: "#{email}_#{i}@gmail.com")
      end
      Contact.stub(:search) { @user.contacts.where("email like '#{email}_%'") }
      get '/contacts/search', contact_search_params(@user.contacts.first.email, 1), @headers
      expect(response).to have_http_status(200)
      expect(hash_response[:data].length).to be 5
    end

    it 'searching with pagination' do
      email = Faker::Lorem.characters(3)
      15.times do |i|
        create(:contact_with_name, user_id: @user.id, name: "sample_contact_#{i}")
      end
      Contact.stub(:search) { @user.contacts.where("name like 'sample_contact_%'") }
      get '/contacts/search', contact_search_params('sample_contact_', 2), @headers
      expect(response).to have_http_status(200)
      expect(hash_response[:data].length).to be 5
    end
  end
end
