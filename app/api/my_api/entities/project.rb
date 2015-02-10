module MyApi
  module Entities
    class Project < Grape::Entity
      expose :id
      expose :name
      expose :owner_names
    end
  end
end
