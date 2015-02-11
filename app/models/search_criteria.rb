class SearchCriteria
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :project, touch: true

  #S.I. units, euros for currency
  field :min_surface, default: 10, type: Integer
  field :max_surface, default: 100, type: Integer
  field :min_price  , default: 1, type: Integer
  field :max_price  , default: 2000, type: Integer
  field :district   , type: String

end
