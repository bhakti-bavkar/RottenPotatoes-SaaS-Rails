FactoryGirl.define do
  factory :movie do
      title 'Default title' # default values
      rating 'PG'
      description 'blah blah'
      release_date 2015-11-26
      director 'Any director'
  end
end