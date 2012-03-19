FactoryGirl.define do
  factory :activity, :class => Joyce::Activity do
    association :actor, :factory => :thing
    verb Joyce::Verb
  end
  
  factory :thing do
    name "The Thing"
  end
  
  factory :person do
    name "The Person"
  end
end
