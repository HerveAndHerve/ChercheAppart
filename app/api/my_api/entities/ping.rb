module MyApi
  module Entities
    class Ping < Grape::Entity
      expose :ping
    end
  end
end
