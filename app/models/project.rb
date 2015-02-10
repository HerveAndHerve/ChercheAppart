class Project
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name

  has_and_belongs_to_many :owners, class_name: "User", inverse_of: :projects

  embeds_one :search_criteria
  embeds_many :ad_lists

end
