require 'webmock/cucumber'
require 'cucumber/rspec/doubles'

Before do
    body = File.read "./features/support/TMDb_response.json"
  stub_request(:any, /api.themoviedb.org/).to_return(:status => 200, :body => body, :headers => {})

end
