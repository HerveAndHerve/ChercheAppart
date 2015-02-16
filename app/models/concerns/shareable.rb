module Shareable
  extend ActiveSupport::Concern

  included do 
    field :token
    index({ token: 1},{sparse: true, unique: true, name: 'project_token_index'})

    before_create :generate_token!

    protected

    def generate_token!
      self.token = loop do
        tok = SecureRandom.urlsafe_base64(nil,false)
        break tok unless self.class.where(token: tok).exists?
      end
    end
  end
end
