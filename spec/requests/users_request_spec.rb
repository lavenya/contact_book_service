require 'rails_helper'

RSpec.describe 'User Requests', type: :request do

  after(:all) do
    User.destroy_all
  end

  describe 'User creation' do
    it 'create new user' do
      params = user_creation_params
      post '/users', params
      expect(response).to have_http_status(200)
      user = User.last
      expect(user).to be_present
      expect(user.name).to eq params[:name]
      expect(user.email).to eq params[:email]
    end

    it 'when password and password confirmation is different' do
      params = invalid_password_params
      post '/users', params
      expect(response).to have_http_status(300)
      expect(hash_response[:errors][0]).to eq("password_confirmation doesn't match Password")
    end

    it 'when email is already present' do
      params = user_creation_params
      post '/users', params
      expect(response).to have_http_status(200)
      post '/users', params
      expect(response).to have_http_status(300)
      expect(hash_response[:errors][0]).to eq('email has already been taken')
    end

    it 'when name is not present' do
      params = user_creation_params
      params.delete(:name)
      post '/users', params
      expect(response).to have_http_status(300)
      expect(hash_response[:errors][0]).to eq("name can't be blank")
    end

    it 'when email is not present' do
      params = user_creation_params
      params.delete(:email)
      post '/users', params
      expect(response).to have_http_status(300)
      expect(hash_response[:errors][0]).to eq("email can't be blank")
    end

    it 'when password is not present' do
      params = user_creation_params
      params.delete(:password)
      post '/users', params
      expect(response).to have_http_status(300)
      expect(hash_response[:errors][0]).to eq("password can't be blank")
    end
  end

  describe 'User updation' do
    before(:each) do
      @user = create(:user)
      @headers = login_headers(@user.email)
    end

    it 'update user' do
      params = user_updation_params
      put "/users/#{@user.id}", params, @headers
      expect(response).to have_http_status(200)
      @user.reload
      expect(@user).to be_present
      expect(@user.name).to eq params[:name]
    end

    it 'update invalid user' do
      params = user_updation_params
      put "/users/#{Faker::Lorem.characters(3)}", params, @headers
      expect(response).to have_http_status(404)
    end

    it 'forbidden update for other user details' do
      second_user = create(:user)
      params = user_updation_params
      put "/users/#{second_user.id}", params, @headers
      expect(response).to have_http_status(403)
    end

    it 'forbid email update' do
      email = Faker::Internet.email
      params = user_updation_params.merge(email: email)
      put "/users/#{@user.id}", params, @headers
      expect(response).to have_http_status(200)
      @user.reload
      expect(@user).to be_present
      expect(@user.name).to eq params[:name]
      expect(@user.email).to_not eq email
    end

    it 'forbid password update' do
      password = Faker::Lorem.characters(3)
      params = user_updation_params.merge(password: password)
      password_before_update = @user.password_digest
      put "/users/#{@user.id}", params, @headers
      @user.reload
      expect(response).to have_http_status(200)
      expect(@user).to be_present
      expect(@user.name).to eq params[:name]
      expect(@user.password_digest).to eq password_before_update
    end
  end

  describe 'User Deletion' do
    before(:each) do
      @user = create(:user)
      @headers = login_headers(@user.email)
    end

    it 'delete user' do
      delete "/users/#{@user.id}", nil, @headers
      expect(response).to have_http_status(200)
      user = User.where(id: @user.id)
      contacts = Contact.where(user_id: @user.id)
      expect(user).to_not be_present
      expect(contacts).to_not be_present
    end

    it 'delete invalid user' do
      delete "/users/#{Faker::Lorem.characters(3)}", nil, @headers
      expect(response).to have_http_status(404)
    end

    it 'forbid delete for other user details' do
      second_user = create(:user)
      put "/users/#{second_user.id}", nil, @headers
      expect(response).to have_http_status(403)
    end
  end
end
