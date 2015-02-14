describe MyApi::V1::Ads do
  describe :get do 
    before do 
      sign_up_and_login!
      @a = FactoryGirl.create(:ad)
    end

    subject(:get_ad) { get "api/ads/#{@a.id}" }

    it "gets ad" do
      get_ad
      puts response.body
      expect(parsed_response.has_key?("ad")).to be true
      expect(parsed_response["ad"]["id"]).to eq @a.id.to_s
    end
  end
end

