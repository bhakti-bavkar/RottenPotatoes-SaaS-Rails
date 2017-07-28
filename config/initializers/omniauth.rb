Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV["TWITTER_APP_KEY"], ENV["TWITTER_APP_SECRET"],
  {
      :authorize_params => {
        :force_login => 'true'
      }
  }
end
