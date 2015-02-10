Rails.application.routes.draw do
  get '/api/users/auth/google_oauth2', to: redirect('/users/auth/google_oauth2')
  devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks'}

  mount API => '/api'
  mount GrapeSwaggerRails::Engine => '/api/doc' unless Rails.env.production?
  root :to => 'static#index'
end
