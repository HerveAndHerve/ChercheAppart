module MyApi
  module Entities
    class Project < Grape::Entity
      expose :id
      expose :name
      expose :owner_names

      expose :new_ads_count
      expose :listed_ads_count
      expose :archived_ads_count

      expose :search_criteria, using: MyApi::Entities::SearchCriteria
    end
  end
end
