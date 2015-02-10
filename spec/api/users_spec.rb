describe MyApi::V1::Users do 

  before(:each) do 
    logout
    User.delete_all
  end

  #{{{ user/me
  describe :me do 
    subject(:get_me) { get '/api/users/me'}
    it "respond with 401 when logged out" do 
      get_me
      expect(response.status).to eq 401
    end
    it "responds with 200 when logged in" do 
      @user = FactoryGirl.create(:user)
      login(@user)
      get_me
      expect(response.status).to eq 200
    end
  end
  #}}}

  #{{{ sign_in
  describe :sign_in do 
    subject(:sign_in) { 
      user = FactoryGirl.create(:user)
      user.confirm! rescue nil
      post 'api/users/sign_in',{user: {password: user.password, email: user.email}}
      }
    it "signs in" do 
      expect{sign_in}.to change{
        get 'api/users/me'
        json_response.has_key?("user")
      }.from(false).to(true)
    end
  end
  #}}}

  #{{{ signup
  describe :signup do 

    subject(:sign_up){ 
      u = FactoryGirl.build(:user)
      post "/api/users", {user: {email:u.email, password:u.password, password_confirmation: u.password}}
    }

    it "should create a user" do 
      expect{sign_up}.to change{User.count}.by(1)
    end

    it "should login the user" do 
      sign_up
      get '/api/users/me'
      expect(response.status).to eq 200
    end

  end
  #}}}

end

