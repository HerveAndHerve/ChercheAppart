module MyApi
  module Entities
    class AdList < Grape::Entity
      expose :name
      expose :ads, using: MyApi::Entities::Ad
    end
  end
end
