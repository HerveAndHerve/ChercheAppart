module StripeForUsers
  extend ActiveSupport::Concern

  included do 
    field :stripe_id
    field :last_charged, type: DateTime

    # Finds or create a stripe customer object associated to the user
    def stripe
      if stripe_id.blank?
        cus = Stripe::Customer.create(
          email: email,
          description: "cherche_appart customer",
        )
        self.update_attribute(:stripe_id, cus.id)
        cus
      else
        Stripe::Customer.retrieve(stripe_id) 
      end
    end

    # Does the user have a valid subscription ? 
    def has_valid_subscription?
      stripe.subscriptions.data.count{|s| %w(active trialing past_due).include? s.status} > 0
    end

    def paid_this_month?
      return false if last_charged.blank?
      last_charged + 1.month > Time.now
    end

    def has_valid_payment_or_subscription?
      paid_this_month? or has_valid_subscription?
    end

    def update_last_charge_datetime!
      self.update_attribute(:last_charged, Time.now)
    end

  end

end
