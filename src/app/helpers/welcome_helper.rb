module WelcomeHelper
  AVAILABLE_WELCOMES = [
    'Welcome',
    'Looking good',
    'Hello'
  ]

  def self.get_one
    AVAILABLE_WELCOMES[rand(AVAILABLE_WELCOMES.size)]
  end
end
