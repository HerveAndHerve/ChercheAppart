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

  after_save :send_alert_emails!

  protected

  def send_alert_emails!
    projects = Project
    .where(send_alert_emails: true)
    .lte('search_criteria.min_surface' => surface)
    .gte('search_criteria.max_surface' => surface)
    .lte('search_criteria.min_price' => price)
    .gte('search_criteria.max_price' => price)
    .any_in(district: [district,nil])

    projects.each do |project|
      project.owners.each do |user|
        NewAdAlert.notify(user,project,self).deliver
      end
    end

  end

end
