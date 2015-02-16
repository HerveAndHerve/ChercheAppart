module MyApi
  module Entities
    class User < Grape::Entity
      expose :id 
      expose :uid
      expose :provider
      expose :image
      expose :name
      expose :allowed_moves_count
      expose :last_charged

    end
  end
end
