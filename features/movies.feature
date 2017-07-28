Feature: search for movies by director
 
  As a movie buff
  So that I can find movies with my favorite director
  I want to include and serach on director information in movies I enter
 
Background: movies in database
 
  Given the following movies exist:
  | title        | rating | director     | release_date |
  | Star Wars    | PG     | George Lucas |   1977-05-25 |
  | Blade Runner | PG     | Ridley Scott |   1982-06-25 |
  | Alien        | R      |              |   1979-05-25 |
  | THX-1138     | R      | George Lucas |   1971-03-11 |
 
 
Scenario: find movie with same director
  Given I am on the details page for "Star Wars"
  When  I follow "Find Movies With Same Director"
  Then  I should be on the Similar Movies page for "Star Wars"
  And   I should see "THX-1138"
  But   I should not see "Blade Runner"
 
Scenario: can't find similar movies if we don't know director (sad path)
  Given I am on the details page for "Alien"
  Then  I should not see "Ridley Scott"
  When  I follow "Find Movies With Same Director"
  Then  I should be on the home page
  And   I should see "'Alien' has no director info"
  
Scenario: sort movies alphabetically
  Given I am on the RottenPotatoes home page
  When I follow "Movie Title"
  Then I should see "Alien" before "Blade Runner"
  
Scenario: Filter out movies with 'PG' or 'R' ratings
  Given I am on the RottenPotatoes home page
  When I check the following ratings: PG,R 
  And I uncheck the following ratings: G,PG-13,NC-17
  And I press "Refresh"
  Then I should see movies with checked ratings
  But I should not see movies with unchecked ratings
  
 
  

