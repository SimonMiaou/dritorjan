require 'dritorjan/models/user'

FactoryBot.define do
  factory :user, class: 'Dritorjan::Models::User' do
    login { Faker::Internet.user_name }
    full_name { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    password { Faker::Internet.password }
  end
end
