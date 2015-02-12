module MyApi
  module V1
    class Subscribe < Grape::API
      format :json

      namespace :subscribe do 

        #{{{ available plans. 
        desc 'get a list of available plans'
        get 'subscribe/available_plans' do 
          plans = %w(cherche_appart_monthly).map{|id| Stripe::Plan.retrieve(id)}
          present :available_plans, plans
        end
        #}}}

        #{{{ publishable key
        desc "get the publishable key for form building"
        get :publishable_key do 
          present :'data-key', ENV['STRIPE_PUBLISHABLE_KEY']
        end
        #}}}

        #{{{ charge price
        desc "get the current price for a one-time month subscription"
        get 'one_month_price' do
          present :price_in_euro, ENV['ONE_TIME_SUBSCRIPTION_PRICE_IN_EURO'].to_i
        end
        #}}}

        #{{{ charge card
        desc "charge a customer to get one month of unlimited moves"
        params do
          requires :stripeToken, type: String, desc: "user's stripe token. required if the user subscribes for the first time, optional otherwise"
        end
        post :one_time_charge do
          sign_in!
          begin
            c = Stripe::Charge.create(
              amount: ENV['ONE_TIME_SUBSCRIPTION_PRICE_IN_EURO'].to_i * 100,
              currency: 'eur',
              card: params[:stripeToken],
              description: "charge for #{current_user.email}",
            )
            current_user.update_last_charge_datetime!
          rescue => e
            error!(e.message)
          end
        end
        #}}}

        #{{{ subscribe to a plan
        desc "subscribe to a recurring plan"
        params do 
          optional :stripeToken, type: String, desc: "user's stripe token. required if the user subscribes for the first time, optional otherwise"
          requires :plan_id, type: String, desc: "id of the plan you want to subscribe to"
        end
        post :subscribe do 
          sign_in!

          # find or create stripe customer from user email and card
          cus = begin 
                  current_user.stripe
                rescue => e
                  error!(e.message)
                end
          unless params[:stripeToken].blank?
            cus.card = params[:stripeToken]
            cus.save
          end

          # find the plan
          begin
            plan = Stripe::Plan.retrieve(params[:plan_id])
          rescue => e
            error!(e.message)
          end

          # subscribe !
          begin
            cus.subscriptions.create(plan: plan.id)
            present :status, :subscribed
          rescue => e
            error!(e.message)
          end

        end
        #}}}

        #{{{ unsubscribe from a plan
        desc "unsubscribe from a plan"
        params do 
          requires :plan_id, type: String, desc: "id of the plan you want to unsubscribe to"
        end
        post :unsubscribe do 
          sign_in!

          # find or create stripe customer from user email and card
          cus = begin 
                  current_user.stripe
                rescue => e
                  error!(e.message)
                end
          unless params[:stripeToken].blank?
            cus.card = params[:stripeToken]
            cus.save
          end

          # find the plan
          begin
            plan = Stripe::Plan.retrieve(params[:plan_id])
          rescue => e
            error!(e.message)
          end

          # unsubscribe !
          begin
            subscription_ids = cus.subscriptions.data.select{|sub| sub.plan.id == plan.id}.map(&:id).uniq
            subscription_ids.each{|sub| cus.subscriptions.retrieve(sub).delete}
            present :status, :unsubscribed
          rescue => e
            error!(e.message)
          end
        end
        #}}}

        #{{{ unsubscribe all plans
        desc "unsubscribe from all my plans"
        delete :deactivate_account do 
          sign_in!
          current_user.stripe.subscriptions.each(&:delete)
          present :status, :deactivated
        end
        #}}}


      end
    end
  end
end
