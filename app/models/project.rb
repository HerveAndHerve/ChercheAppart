class Project
  include Mongoid::Document
  include Mongoid::Timestamps
  include Shareable

  field :name
  field :send_alert_emails, type: Boolean, default: false
  
  validates_presence_of :name

  has_and_belongs_to_many :owners, class_name: "User", inverse_of: :projects

  embeds_one :search_criteria, class_name: "SearchCriteria"
  embeds_many :ad_lists

  after_initialize :set_default_lists
  after_initialize :set_default_criteria

  def owner_names
    owners.only(&:name).map(&:name)
  end

  def new_ads_count
    Rails.cache.fetch("PrjcAdsCnt|#{id}|#{updated_at.to_i}", expires_in: 5.minutes) do 
      new_ads.count
    end
  end

  def new_ads
    s = search_criteria
    ads = Ad
    .where(active_url: true)
    .gte(surface: s.min_surface)
    .lte(surface: s.max_surface)
    .gte(price: s.min_price)
    .lte(price: s.max_price)
    .not.any_in(id: ad_lists.flat_map(&:ad_ids).uniq)
    .desc(:created_at)

    unless s.district.blank?
      ads = ads.where(district: s.district)
    end

    ads
  end

  def public_ad_lists
    ad_lists.where(hidden: false)
  end

  def listed_ads_count
    public_ad_lists.map(&:ads_count).reduce(:+)
  end

  def archived_ads_count
    ad_lists.find_or_create_by(name: "archivé").ads_count
  end

  private

  def set_default_lists
    ['archivé','intéressant','à contacter','en attente','rendez vous pris','dossier déposé','accepté','refusé'].each do |k|
      AdList.create(name: k, project: self, hidden: (k == 'archivé')) unless ad_lists.where(name: k).exists?
    end
  end

  def set_default_criteria
    self.search_criteria = SearchCriteria.new unless !!search_criteria
  end

end
