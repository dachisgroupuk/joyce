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
  
  factory :stream, :class => Joyce::Stream do
    association :owner, :factory => :thing
  end
end
