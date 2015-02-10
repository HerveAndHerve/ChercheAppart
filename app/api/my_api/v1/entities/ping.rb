module MyApi
  module V1
    module Entities
      class Ping < Grape::Entity
        expose :ping
      end
    end
  end
end
