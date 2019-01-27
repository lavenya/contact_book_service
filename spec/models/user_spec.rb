# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  after(:all) do
    User.destroy_all
  end
  describe 'Associations' do
    it 'validates associations' do
      t = User.reflect_on_association(:contacts)
      expect(t.macro).to eq(:has_many)
    end
  end

  describe 'Validation' do
    it 'save user' do
      user = User.create(name: Faker::Name.name, email: Faker::Internet.email,
                          password: Faker::Lorem.characters(3))
      expect(user).to be_present
      expect(user.errors).to be_blank
    end

    it 'invalid name' do
      user = User.create(email: Faker::Internet.email, password: Faker::Lorem.characters(3))
      expect(user.errors).to be_present
      expect(user.errors.messages[:name][0]).to eq "can't be blank"
    end

    it 'invalid email' do
      user = User.create(name: Faker::Name.name, password: Faker::Lorem.characters(3))
      expect(user.errors).to be_present
      expect(user.errors.messages[:email][0]).to eq "can't be blank"
    end

    it 'invalid password' do
      user = User.create(name: Faker::Name.name, email: Faker::Internet.email)
      expect(user.errors).to be_present
      expect(user.errors.messages[:password][0]).to eq "can't be blank"
    end

    it 'duplicate email' do
      email = Faker::Internet.email
      user = User.create(name: Faker::Name.name, email: email, password: Faker::Lorem.characters(3))
      second_user = User.create(name: Faker::Name.name, email: email, password: Faker::Lorem.characters(3))
      expect(second_user.errors).to be_present
      expect(second_user.errors.messages[:email][0]).to eq "has already been taken"
    end
  end
end
