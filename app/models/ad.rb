class Ad
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :url
  field :provider

  field :surface
  field :price
  field :picture
  field :description
  field :location

  validates_presence_of :url, :surface, :price
  validates_uniqueness_of :url, :surface, :price

end
