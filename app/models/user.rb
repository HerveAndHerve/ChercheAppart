class User
  include Mongoid::Document
  include GoogleOmniauth
  include Facebookable
  include StripeForUsers

  field :image
  field :provider
  field :uid
  field :first_name, type: String, default: ""
  field :last_name, type: String, default: ""
  field :allowed_moves_count, type: Integer, default: (ENV["FREE_MOVES_LIMIT"] || 20).to_i

  has_and_belongs_to_many :projects, class_name: "Project", inverse_of: :owners

  #{{{ devise
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :trackable
  devise :omniauthable, omniauth_providers: [:google_oauth2, :facebook]

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time
  #}}}

  def name
    [first_name || '', last_name || ''].map(&:capitalize).join(" ")
  end

  def claim_project!(project,token)
    return nil unless project.token == token
    return project.owners << self
  end

  def enlist_ad!(project, ad,list_name_or_id)
    raise "user doesn't own this project" unless project.owners.include? self
    paying_move do 
      raise "#{ad} is not an Ad" unless ad.is_a? Ad
      project.ad_lists.each{|al| al.ad_ids.delete(ad.id) ; al.save}
      list = project.ad_lists.find(list_name_or_id) || project.ad_lists.find_or_create_by(name: list_name_or_id)
      list.ad_ids << ad.id
      list.save
    end
  end

  def unlist_ad!(project, ad,list_name_or_id)
    raise "user doesn't own this project" unless project.owners.include? self
    paying_move do 
      raise "#{ad} is not an Ad" unless ad.is_a? Ad
      list = project.ad_lists.find(list_name_or_id) || project.ad_lists.find_by(name: list_name_or_id) || (return nil)
      list.ad_ids.delete(ad.id)
      list.save
    end
  end

  #{{{ mongo/devise monkey patch
  class << self
    def serialize_from_session(key,salt)
      record = to_adapter.get(key[0]["$oid"]) || to_adapter.get(key)
      record if record && record.authenticatable_salt == salt
    end
  end
  #}}}

  private

  def paying_move
    raise "quota_excedeed" if self.allowed_moves_count <= 0 and !has_valid_payment_or_subscription?
    if a = yield
      self.inc(allowed_moves_count: -1) unless !has_valid_payment_or_subscription?
      return a
    end
  end

end
