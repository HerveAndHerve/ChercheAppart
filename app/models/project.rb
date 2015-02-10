class Project
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name

  has_and_belongs_to_many :owners, class_name: "User", inverse_of: :projects

  embeds_one :search_criteria
  embeds_many :ad_lists

  after_initialize :set_default_lists

  def owner_names
    owners.only(&:name).map(&:name)
  end

  private

  def set_default_lists
    %w(interesting to_contact waiting appointment_taken folder_given accepted refused).each do |k|
      AdList.create(name: k, project: self)
    end
  end

end
