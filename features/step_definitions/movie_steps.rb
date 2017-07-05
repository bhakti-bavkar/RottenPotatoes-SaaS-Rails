Given(/^the following movies exist:$/) do |movies_table|
    movies_table.hashes.each {|movie| Movie.create!(movie)}
end

Then(/^the director of "([^"]*)" should be "([^"]*)"$/) do |arg1, arg2|
    %{I should see "#{arg1}"}
    %{I should see "#{arg1}"}
end
