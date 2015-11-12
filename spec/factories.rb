FactoryGirl.define do
  factory :user do
    sequence(:email) {|i| "john+#{i}@factories.page-gauge.io" }
  end

  factory :site do
    sequence(:url) {|i| "http://#{i}.example.com/#{i}-in32fdi9" }
  end

end
