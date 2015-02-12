class Ad
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :url
  field :active_url, default: true
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

  def check_url!
    active = ( ( Faraday.head(url).status != 404 ) rescue false)
    self.active_url = active
    self.save if self.changed?
    return active
  end

end
