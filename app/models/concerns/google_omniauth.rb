module GoogleOmniauth
  extend ActiveSupport::Concern

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
