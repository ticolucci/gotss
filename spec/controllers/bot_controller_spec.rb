require 'rails_helper'

RSpec.describe BotController, :type => :controller do

  describe "GET idnex" do
    it "returns http success" do
      get :idnex
      expect(response).to have_http_status(:success)
    end
  end

end
