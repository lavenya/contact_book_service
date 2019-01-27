# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Searchable Lib' do
  after(:all) do
    Contact.destroy_all
    User.destroy_all
  end

  describe 'Search helper' do
    it 'Elasticsearch payload' do
      user = create(:user)
      contact = Contact.create(name: Faker::Name.name, email: Faker::Internet.email, user_id: user.id)
      expect(contact.as_indexed_json).to eq contact.es_payload  
    end

    it 'es search' do
      expect(Contact).to respond_to(:es_search_with_pagination).with(3).argument
    end

    it 'search payload' do
      expect(Contact).to respond_to(:search).with(2).argument
    end
  end
end