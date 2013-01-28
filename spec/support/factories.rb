require 'factory_girl'

FactoryGirl.define do

  factory :product do
    trait :base do
      sequence(:id)
      name {'Magic'}
      description {"Do it like someone else"}
    end
  end

  factory :user do
    trait :base do
      sequence(:id)
      name {'Magic'}
      email {"test@test.com"}
    end
  end

end
