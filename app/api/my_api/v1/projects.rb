module MyApi
  module V1
    class Projects < Grape::API
      format :json

      namespace :projects do 
        before do 
          sign_in!
        end

        #{{{ index (my projects)
        desc "get my list of projects"
        get do 
          present :projects, current_user.projects, with: MyApi::Entities::Project
        end
        #}}}

      end

    end
  end
end
