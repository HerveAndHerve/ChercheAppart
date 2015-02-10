module MyApi
  module Entities
    class Ad < Grape::Entity
      expose :url
    end
  end
end

