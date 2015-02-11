describe MyApi::V1::Projects do 

  #{{{ index
  describe :index do 
    subject(:index) { get '/api/projects' }

    context 'when logged off' do 
      it "requires login" do 
        index
        expect(response.status).to eq 401
      end
    end

    context 'when logged in' do 
      before do 
        sign_up_and_login!
      end
      it "shows my projects" do 
        index
        expect(parsed_response.has_key?("projects")).to be true
      end
    end

  end
  #}}}

  #{{{ udpate
  describe :update do 
    before do
      sign_up_and_login!
      @project = FactoryGirl.build(:project)
      @project.owners << @user
    end
    let(:ps) {
      {
        name: 'new name',
        search_criteria: {
          "min_surface" => 28000,
          "max_surface" => 28000,
          "min_price" => 28000,
          "max_price" => 28000,
          "district" => 'absurd',
        },
      }
    }

    subject(:update) { put "api/projects/#{@project.id}", ps ; @project.reload ; @project.search_criteria.reload}

    it 'update updates criteria' do 
      expect{update}.to change{@project.search_criteria.attributes.slice(*ps[:search_criteria].keys)}.to(ps[:search_criteria])
    end

    it 'update updates name' do 
      expect{update}.to change{@project.name}.to(ps[:name])
    end

  end


  #}}}

end
