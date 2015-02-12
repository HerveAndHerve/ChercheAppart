module MyApi
  module Entities
    class User < Grape::Entity
      expose :id 
      expose :provider
      expose :image

      expose :name

    end
  end
end
