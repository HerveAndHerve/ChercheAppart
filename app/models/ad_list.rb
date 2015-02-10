class AdList
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :project
end
