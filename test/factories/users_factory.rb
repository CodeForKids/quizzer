FactoryGirl.define do
  factory :admin, :class => "User" do
    first_name "julian"
    last_name "nadeau"
    password "12345678"
    email "julian@codeforkids.ca"
  end

  factory :kid, :class => "User" do
    first_name "bob"
    last_name "smith"
    password "12345678"
    email "bob@example.com"
  end

  factory :kid2, :class => "User" do
    first_name "bobbie"
    last_name "smiths"
    password "12345678"
    email "bobbie@example.com"
  end
end
