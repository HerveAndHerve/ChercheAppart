module Facebookable
  extend ActiveSupport::Concern

  module ClassMethods
    def find_for_facebook(auth)

      where(auth.slice(:provider, :uid)).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.first_name = auth.info.first_name   # assuming the user model has a name
        user.last_name  = auth.info.last_name   # assuming the user model has a name
        user.image = auth.info.image
        user
      end

    end
  end
end
