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

  def enlist_ad!(ad,list_name_or_id)
    raise "#{ad} is not an Ad" unless ad.is_a? Ad
    ad_lists.each{|al| al.ad_ids.delete(ad.id) ; al.save}
    list = ad_lists.find(list_name_or_id) || ad_lists.find_or_create_by(name: list_name_or_id)
    list.ad_ids << ad.id
    list.save
  end

  def unlist_ad!(ad,list_name_or_id)
    raise "#{ad} is not an Ad" unless ad.is_a? Ad
    list = ad_lists.find(list_name_or_id) || ad_lists.find_by(name: list_name_or_id) || (return nil)
    list.ad_ids.delete(ad.id)
    list.save
  end

  def public_ad_lists
    ad_lists.where(hidden: false)
  end

  private

  def set_default_lists
    %w(archived interesting to_contact waiting appointment_taken folder_given accepted refused).each do |k|
      AdList.create(name: k, project: self, hidden: (k == 'archived')) unless ad_lists.where(name: k).exists?
    end
  end

  def set_default_criteria
    self.search_criteria = SearchCriteria.new unless !!search_criteria
  end

end
