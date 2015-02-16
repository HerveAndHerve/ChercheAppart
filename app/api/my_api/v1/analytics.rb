module MyApi
  module V1
    class Analytics < Grape::API
      format :json

      namespace :analytics do

        #{{{ mixpanel
        get :mixpanel do
          present :token, ENV["MIXPANEL_TOKEN"]
        end
        #}}}

      end

    end
  end
end
