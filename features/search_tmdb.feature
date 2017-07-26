Feature: User can add movie by searching for it in The Movie Database (TMDb)

  As a movie fan
  So that I can add new movies without manual tedium
  I want to add movies by looking up their details in TMDb

Background: Start from the Search form on the home page
  Given I am on the RottenPotatoes home page
  Then I should see "Search TMDb for a movie"

Scenario: Try to add nonexistent movie (sad path)
  When I search for "Movie That Does Not Exist" from TMDb
  Then I should be on the RottenPotatoes home page
  And I should see "'Movie That Does Not Exist' was not found in TMDb."

Scenario: Try to add existing movie (happy path)
  When I search for "Inception" from TMDb
  Then I should be on the create new movie page
  And I should not see "not found"
  And I should see "Inception"