@transaction
Feature: add, delete and edit movies
  
  As a RottenPotatoes User
  In order to eadd, edit or delete movie details
  I need to be authorized first
  
Background: movies in database
 
  Given the following movies exist:
  | title        | rating | director     | release_date |
  | Star Wars    | PG     | George Lucas |   1977-05-25 |
  | Blade Runner | PG     | Ridley Scott |   1982-06-25 |
  | Alien        | R      |              |   1979-05-25 |
  | THX-1138     | R      | George Lucas |   1971-03-11 |
  And I am logged in with twitter

Scenario: Create new movie
  Given I am on the RottenPotatoes home page
  And I follow "Add new movie"
  Then I should be on the create new movie page
  And I fill new movie details for "Independance Day"
  And I press "Save Changes"
  Then I should be on the home page
  And I should see "Independance Day was successfully created."
  
Scenario: Delete existing movie
  Given I am on the details page for "Alien"
  And I press "Delete"
  Then  I should be on the home page
  And I should see "Movie 'Alien' deleted."
  
Scenario: add director to existing movie
  When I go to the edit page for "Alien"
  And  I fill in "Director" with "Ridley Scott"
  And  I press "Update Movie Info"
  Then the director of "Alien" should be "Ridley Scott"
  
