Rails.application.routes.draw do
  post "/bot-#{BOT_TOKEN}/" => 'bot#index'

  post "/bot-#{BOT_TOKEN}/kick-all" => 'bot#kick_all'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
