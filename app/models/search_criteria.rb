class SearchCriteria
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :project

  #S.I. units, euros for currency
  field :min_surface
  field :max_surface
  field :min_price
  field :max_price

end
