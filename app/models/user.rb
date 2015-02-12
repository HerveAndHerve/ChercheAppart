class User
  include Mongoid::Document
  include GoogleOmniauth
  include Facebookable

  field :image
  field :provider
  field :uid
  field :first_name, type: String, default: ""
  field :last_name, type: String, default: ""

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

  class << self
    def serialize_from_session(key,salt)
      record = to_adapter.get(key[0]["$oid"]) || to_adapter.get(key)
      record if record && record.authenticatable_salt == salt
    end
  end

end
