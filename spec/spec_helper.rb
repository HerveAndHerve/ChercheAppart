ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.infer_spec_type_from_file_location!

  config.before(:each) do 
    Mongoid.purge!
  end
end

def parsed_response
  JSON.parse(@response.body)
end

def sign_up_and_login!
  @user = FactoryGirl.create(:user)
  login(@user)
  @user
end

def login(user)
  post '/api/users/sign_in', {user: {email: user.email, password: user.password}}
end

def logout
  get '/api/users/sign_out'
end
