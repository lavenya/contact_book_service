# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Error lib' do
  describe 'Error Object' do
    it 'initialize error' do
      contact = Contact.create(name: Faker::Name.name)
      error = ::ContactBookErrors::Error(contact.errors)
      expect(error.object_error).to eq contact.errors
      expect(error.error_messages).to eq []
    end

    it 'collect all error messages' do
      contact = Contact.create(name: Faker::Name.name)
      error = ::ContactBookErrors::Error(contact.errors)
      expect(error.messages).to be_present
    end
  end
end
