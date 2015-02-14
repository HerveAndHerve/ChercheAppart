module MyApi
  module V1
    class Ads < Grape::API
      format :json

      namespace :ads do 
        before do 
          sign_in!
        end

        namespace ':ad_id' do
          before do 
            @ad = Ad.find(params[:ad_id]) || error!("not found",404)
          end

          #{{{ get
          desc "view an ad details"
          get do 
            present :ad, @ad, with: MyApi::Entities::Ad
          end
          #}}}

        end

      end
    end
  end
end
