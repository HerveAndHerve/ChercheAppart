module MyApi
  module V1
    module Helpers
      module Session

        def session
          env[Rack::Session::Abstract::ENV_SESSION_KEY]
        end

        def warden
          env['warden']
        end

        def current_user
          warden.user
        end

        def sign_in!
          error!("please login",401) unless !!current_user
        end

      end
    end
  end
end
