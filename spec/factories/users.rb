# frozen_string_literal: true

FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { "#{Faker::Internet.email}_#{(Time.now.to_f * 100).ceil}" }
    password { 'test' }
  end
end
