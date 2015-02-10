module MyApi
  module V1
    class Users < Grape::API
      format :json

      namespace :users do 

        #{{{ me
        desc "get my profile informations"
        get :me do 
          sign_in!
          present :user, current_user, with: MyApi::V1::Entities::User
        end
        #}}}

        #{{{ sign_out
        desc "signs out current_user"
        get :sign_out do 
          sign_out
          present :status, :signed_out
        end
        #}}}
        
        #{{{ sign_in
        desc "sign_in user using email/password"
        params do 
          requires :user, type: Hash do 
            requires :email, type: String, desc: "email"
            requires :password, type: String, desc: "password"
          end
        end
        post :sign_in do 
          if (u = User.find_by(email: params[:user][:email])) and u.valid_password?(params[:user][:password])
            sign_in(:user, u)
            present :user, current_user, with: MyApi::V1::Entities::User
            present :status, :signed_in
          else
            error!("wrong password/email combination",401)
          end
        end
        #}}}

        #{{{ signup
        desc "signup user"
        params do 
          optional :user, type: Hash do 
            requires :email, type: String, desc: "user's email"
            requires :password, type: String, desc: "password"
            requires :password_confirmation, type: String, desc: "password_confirmation"
          end
        end
        post do
          u = User.new(email: params[:user][:email], password: params[:user][:password], password_confirmation: params[:user][:password_confirmation])
          if u.save
            sign_in(:user, u)
            present :user, u, with: MyApi::V1::Entities::User
          else
            error! u.errors
          end
        end
        #}}}

      end
    end
  end
end
