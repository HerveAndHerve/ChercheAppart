module MyApi
  module Entities
    class AdList < Grape::Entity
      expose :id
      expose :name
      expose :ads_count
      expose :ads, using: MyApi::Entities::Ad, if: {complete: true}
    end
  end
end
