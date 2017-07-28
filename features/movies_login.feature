Feature: Login using twitter credentials
  
  As a RottenPotatoes User
  In order to add, edit or delete movie details
  I need to login into RottenPotatoes using my twitter login credentials
  
@omniauth_test
Scenario: Logging In
  Given I am on the RottenPotatoes home page
  Then I should see "Log in"
  When I follow "Log in"
  Then I should be on the login page
  When I follow "Log in with your Twitter account"
  Then I should see "Welcome, Twitter User!"
