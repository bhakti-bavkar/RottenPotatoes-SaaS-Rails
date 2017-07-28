require 'cucumber/rspec/doubles'

Given(/^the following movies exist:$/) do |movies_table|
    movies_table.hashes.each {|movie| Movie.create!(movie)}
end

Then(/^the director of "([^"]*)" should be "([^"]*)"$/) do |arg1, arg2|
    %{I should see "#{arg1}"}
    %{I should see "#{arg1}"}
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  regexp = /#{e1}.*#{e2}/m
  expect(page.body).to match(regexp)
end

When /I check the following ratings: (.*)/ do |rating_list|
  rating_list.gsub(' ','').split(',').each {|x| check("ratings_#{x}")}
end

When /I uncheck the following ratings: (.*)/ do |rating_list|
  rating_list.gsub(' ','').split(',').each {|x| uncheck("ratings_#{x}")}
end

Then /I should see movies with checked ratings/ do
  rating_list = []
  page.all(:xpath, '//input[@type="checkbox"][@checked="checked"]').each do |x|
    rating_list << x['id'][8..-1]
  end
  page.all('table#movies tbody tr').each do |tr| 
    table_rating = tr.all('td')[1].text
    expect(rating_list).to include(table_rating)
  end
end

Then /I should not see movies with unchecked ratings/ do
  rating_list = []
  page.all(:xpath, '//input[@type="checkbox"]').each do |x|
    next if x.checked?
    rating_list << x['id'][8..-1]
  end
  page.all('table#movies tbody tr').each do |tr| 
    table_rating = tr.all('td')[1].text
    expect(rating_list).not_to include(table_rating)
  end
end


When /I fill new movie details for (.*)/ do |title|
    steps %Q{
        When I fill in "Title" with #{title}
        And I select "G" from "Rating"
        And I fill in "Director" with "Roland Emmerich"
    }
end

When /I search for (.*) from TMDb/ do |title|
  if title.match(/Inception/)
    body = File.read "./features/support/TMDb_response.json"
  else
    body = File.read "./features/support/TMDb_empty.json"
  end
  stub_request(:any, /api.themoviedb.org/).to_return(:status => 200, :body => body, :headers => {})
  steps %Q{
    When I fill in "Search Terms" with #{title}
    And I press "Search TMDb"
  }
end

When /I am logged in with twitter/ do
  visit "/auth/twitter"
end

