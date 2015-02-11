module MyApi
  module Entities
    class Ad < Grape::Entity
      expose :id
      expose :url
      expose :surface
      expose :price
      expose :provider
      expose :district
      expose :img
      expose :description
      expose :location
    end
  end
end

