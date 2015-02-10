describe MyApi::V1::Ping do 

  describe :ping do 
    it "pongs" do 
      get '/api/ping'
      expect(json_response).to eq({"ping" => {"ping" => "pong"}})
    end
  end

end
