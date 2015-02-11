module MyApi
  module Entities
    class SearchCriteria < Grape::Entity
      expose :min_surface
      expose :max_surface
      expose :min_price  
      expose :max_price  
      expose :district   
    end
  end
end
