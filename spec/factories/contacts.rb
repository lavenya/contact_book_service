# frozen_string_literal: true

FactoryGirl.define do
  factory :contact do
    name { Faker::Name.name }
    email { "#{Faker::Internet.email}_#{(Time.now.to_f * 100).ceil}" }
    user_id { user_id }
  end

  factory :contact_with_name, parent: :contact do
    name { name }
    email { "#{Faker::Internet.email}_#{(Time.now.to_f * 100).ceil}" }
    user_id { user_id }
  end

  factory :contact_with_email, parent: :contact do
    name { Faker::Name.name }
    email { email }
    user_id { user_id }
  end
end
