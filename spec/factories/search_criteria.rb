FactoryGirl.define do
  factory :search_criteria, :class => 'SearchCriteria' do
    min_surface 10
    max_surface 100
    min_price 1
    max_price 5000
  end

end
