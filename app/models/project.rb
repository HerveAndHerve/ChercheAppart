class Project
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name

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

  private

  def set_default_lists
    if ad_lists.empty?
      %w(interesting to_contact waiting appointment_taken folder_given accepted refused).each do |k|
        AdList.create(name: k, project: self)
      end
    end
  end

  def set_default_criteria
    if !search_criteria
      self.search_criteria = SearchCriteria.new
    end
  end

end
