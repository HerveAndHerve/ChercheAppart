class AdList
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :project

  field :name
  field :ad_ids, type: Array, default: []

  def ads
    Ad.where(id: ad_ids)
  end
end
