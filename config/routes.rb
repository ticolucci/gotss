Rails.application.routes.draw do
  post "/bot-#{BOT_TOKEN}/" => 'bot#index'

  post "/bot-#{BOT_TOKEN}/kick-all" => 'bot#kick_all'
end
