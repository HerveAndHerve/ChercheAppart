module MyApi
  module V1
    module Entities
      class User < Grape::Entity
        expose :id do |user,options| 
          user.id.to_s
        end
      end
    end
  end
end
