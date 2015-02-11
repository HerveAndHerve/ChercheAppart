require 'rails_helper'

RSpec.describe Project, :type => :model do

  it 'factory validates' do
    assert FactoryGirl.build(:project).valid?
  end

end
