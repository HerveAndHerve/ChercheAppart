FactoryGirl.define do
  factory :project do
    name 'le projet locatif de Madame Pichon'
    search_criteria { FactoryGirl.build(:search_criteria) }
    owners { [User.last || FactoryGirl.build(:user)] }
    #association :search_criteria
    #association :owners, factory: :user
  end

end
