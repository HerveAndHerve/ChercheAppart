class SearchCriteria
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :project
end
