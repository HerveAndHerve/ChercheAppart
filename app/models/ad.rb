class Ad
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :url
  field :provider
  field :district, type: String

  field :surface
  field :price
  field :img
  field :description
  field :location

  validates_presence_of :url, :surface, :price
  validates_uniqueness_of :url

  index({ url: 1},{sparse: false, unique: true, name: 'url_land_index'})

end
