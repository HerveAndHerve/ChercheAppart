require 'rails_helper'

RSpec.describe User, :type => :model do

  #{{{ paid_this_month
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
  #}}}

  #{{{ claim project
  describe :claim_project do
    before do
      @p = FactoryGirl.create(:project)
      @u = FactoryGirl.create(:user)
    end

    subject(:claim) { @u.claim_project!(@p, @p.token) ; @p.reload}
    subject(:claim_with_wrong_token) { @u.claim_project!(@p, 'nope') ; @p.reload}

    it 'claims project with proper token' do
      expect{claim}.to change{@p.owners.include?(@u)}.from(false).to(true)
    end

    it 'does NOT claim any project with wrong token' do
      refute @p.owners.include?(@u)
      expect{claim_with_wrong_token}.to_not change{@p.owners.include?(@u)}
    end
  end
  #}}}

end
