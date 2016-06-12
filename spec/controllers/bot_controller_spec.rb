require 'rails_helper'

RSpec.describe BotController, :type => :controller do

  describe "POST index" do
    it "returns http success" do

      post :index,
      {
        "update_id"=>535269722,
        "message"=>{
          "message_id"=>7,
          "from"=>{
            "id"=>54177008,
            "first_name"=>"Thiago",
            "last_name"=>"Colucci",
            "username"=>"ticolucci"
          },
          "chat"=>{
            "id"=>54177008,
            "first_name"=>"Thiago",
            "last_name"=>"Colucci",
            "username"=>"ticolucci",
            "type"=>"private"
          },
          "date"=>1465757559,
          "text"=>"/hi",
          "entities"=>[
            {
              "type"=>"bot_command",
              "offset"=>0,
              "length"=>3
            }
          ]
        },
        "bot"=>{
          "update_id"=>535269722,
          "message"=>{
            "message_id"=>7,
            "from"=>{
              "id"=>54177008,
              "first_name"=>"Thiago",
              "last_name"=>"Colucci",
              "username"=>"ticolucci"
            },
            "chat"=>{
              "id"=>54177008,
              "first_name"=>"Thiago",
              "last_name"=>"Colucci",
              "username"=>"ticolucci",
              "type"=>"private"
            },
            "date"=>1465757559,
            "text"=>"/hi",
            "entities"=>[
              {
                "type"=>"bot_command",
                "offset"=>0,
                "length"=>3
              }
            ]
          }
        }
      }
      expect(response).to have_http_status(:success)
    end
  end

end
