require 'grape-swagger'

class API < Grape::API
  version :v1, using: :accept_version_header, format: :json, default_format: :json do 

    helpers Devise::Controllers::SignInOut
    helpers Devise::Controllers::StoreLocation
    helpers MyApi::V1::Helpers::Session

    # Mount some api methods
    mount MyApi::V1::Ping
    mount MyApi::V1::Users

    # Generate an api documentation
    add_swagger_documentation(mount_path: '/doc/swagger_doc', base_path: '/api') 

  end

end
