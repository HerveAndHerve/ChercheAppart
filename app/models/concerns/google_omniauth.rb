module GoogleOmniauth
  extend ActiveSupport::Concern

  included do 
    field :provider
    field :uid
    field :first_name, type: String, default: ""
    field :last_name, type: String, default: ""
    field :image, type: String
  end

  module ClassMethods
    def find_for_google_oauth2(auth)
      u = User.find_or_initialize_by(uid: auth.uid, provider: auth.provider)
      u.write_attributes(
        first_name: auth.info.first_name,
        last_name: auth.info.last_name,
        image: auth.info.image,
        email: auth.info.email,
      )
      u.save
      u
    end
  end
  
end
