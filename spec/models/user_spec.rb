require 'rails_helper'

RSpec.describe User, :type => :model do
  describe :paid_this_month? do
    before do 
      @user = FactoryGirl.build(:user)
    end

    it 'returns false if nothing happened' do
      @user.last_charged = nil
      expect(@user.paid_this_month?).to be false
    end

    it 'returns true if user paid 3 days ago' do 
      @user.last_charged = Date.today - 3.days
      expect(@user.paid_this_month?).to be true
    end

    it 'returns false if user paid more than one month ago' do
      @user.last_charged = Date.today - 2.month
      expect(@user.paid_this_month?).to be false
    end

  end
end
