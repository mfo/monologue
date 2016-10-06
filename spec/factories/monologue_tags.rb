FactoryGirl.define do
  factory :tag, class: Monologue::Tag do
    name 'Rails'
    association :site
  end
end
