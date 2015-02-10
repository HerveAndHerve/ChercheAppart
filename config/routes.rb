Rails.application.routes.draw do
  devise_for :users
  mount API => '/api'
  mount GrapeSwaggerRails::Engine => '/api/doc'
end
