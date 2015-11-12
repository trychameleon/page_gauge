FactoryGirl.define do
  factory :user do
    sequence(:email) {|i| "john+#{i}@factories.page-gauge.io" }
  end
end
