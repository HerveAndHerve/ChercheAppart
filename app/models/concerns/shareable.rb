module Shareable
  extend ActiveSupport::Concern

  included do 
    field :saved_token
    index({ saved_token: 1},{sparse: true, unique: true, name: 'project_token_index'})

    def shareable_token
      tok = saved_token.present? ? saved_token : generate_token!
    end

    protected

    def generate_token!
      t = loop do
        tok = SecureRandom.urlsafe_base64(nil,false)
        break tok unless self.class.where(token: tok).exists?
      end
      return t if self.update_attribute(:saved_token,t)
    end
  end
end
