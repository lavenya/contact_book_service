# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contact, type: :model do
  after(:all) do
    Contact.destroy_all
    User.destroy_all
  end
  describe 'Contact associations' do
    it 'validates associations' do
      t = Contact.reflect_on_association(:user)
      expect(t.macro).to eq(:belongs_to)
    end
  end

  describe 'Validation' do
    it 'save contact' do
      contact = Contact.create(name: Faker::Name.name, email: Faker::Internet.email)
      expect(contact).to be_present
      expect(contact.errors).to be_blank
    end

    it 'invalid name' do
      contact = Contact.create(email: Faker::Internet.email)
      expect(contact.errors).to be_present
      expect(contact.errors.messages[:name][0]).to eq "can't be blank"
    end

    it 'invalid email' do
      contact = Contact.create(name: Faker::Name.name)
      expect(contact.errors).to be_present
      expect(contact.errors.messages[:email][0]).to eq "can't be blank"
    end

    it 'duplicate email' do
      email = Faker::Internet.email
      contact = Contact.create(name: Faker::Name.name, email: email)
      second_contact = Contact.create(name: Faker::Name.name, email: email)
      expect(second_contact.errors).to be_present
      expect(second_contact.errors.messages[:email][0]).to eq 'already exists'
    end
  end

  describe 'search query' do
    it 'check search payload' do
      expect(Contact).to respond_to(:search_query).with(2).argument
    end
  end
end
