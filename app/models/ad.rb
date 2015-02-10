class Ad
  include Mongoid::Document
  include Mongoid::Timestamps

  field :url
  field :provider

  validates_presence_of :url
  validates_uniqueness_of :url
end
