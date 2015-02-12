class AdList
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :project, touch: true

  field :name
  field :ad_ids, type: Array, default: []
  field :hidden, type: Boolean

  def ads
    Ad.any_in(id: ad_ids)
  end

  def ads_count
    ad_ids.size
  end

end
