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

  describe :enlist_ad do 
    before do 
      sign_up_and_login!
      @p = FactoryGirl.build(:project)
      @p.owners << @user
      @a = FactoryGirl.build(:ad)
      @p.save
      @a.save
      @user.save
    end

    subject(:enlist_with_new_name) { post "/api/projects/#{@p.id}/ads/#{@a.id}/enlist", {list_name_or_id: 'tagada'} ; @p.reload}
    subject(:enlist_with_existing_name) { post "/api/projects/#{@p.id}/ads/#{@a.id}/enlist", {list_name_or_id: 'interesting'} ; @p.reload}
    subject(:enlist_with_id)  { post "/api/projects/#{@p.id}/ads/#{@a.id}/enlist", {list_name_or_id: @p.ad_lists.find_by(name: 'interesting').id} ; @p.reload} 
    subject(:unlist_with_id)  { post "/api/projects/#{@p.id}/ads/#{@a.id}/unlist", {list_name_or_id: @p.ad_lists.find_by(name: 'interesting').id} ; @p.reload} 
    subject(:archive) {post "/api/projects/#{@p.id}/ads/#{@a.id}/archive" ; @p.reload}
    subject(:unarchive) {post "/api/projects/#{@p.id}/ads/#{@a.id}/unarchive" ; @p.reload}

    describe 'enlist with new name' do 

      it 'creates list' do 
        expect{enlist_with_new_name}.to change{@p.ad_lists.count}.by(1)
      end

      it 'creates list with proper name' do 
        expect{enlist_with_new_name}.to change{@p.ad_lists.last.name}.to('tagada')
      end

      it 'adds the ad to the list' do 
        expect{enlist_with_new_name}.to change{@p.ad_lists.last.ad_ids.include?(@a.id)}.from(false).to(true)
      end

    end

    describe 'enlist with existing name' do 
      it 'does NOT creates list' do 
        expect{enlist_with_existing_name}.to change{@p.ad_lists.count}.by(0)
      end
      it 'adds the ad to the list' do 
        expect{enlist_with_existing_name}.to change{@p.ad_lists.find_by(name: 'interesting').ad_ids.include?(@a.id)}.from(false).to(true)
      end
    end
    
    describe 'enlist with id' do 
      it 'does NOT creates list' do 
        expect{enlist_with_id}.to change{@p.ad_lists.count}.by(0)
      end
      it 'adds the ad to the list' do 
        expect{enlist_with_id}.to change{@p.ad_lists.find_by(name: 'interesting').ad_ids.include?(@a.id)}.from(false).to(true)
        expect{unlist_with_id}.to change{@p.ad_lists.find_by(name: 'interesting').ad_ids.include?(@a.id)}.from(true).to(false)
      end
    end
    
    describe 'archive' do
      it 'archives' do
        expect{archive}.to change{@p.ad_lists.find_by(name: 'archived').ad_ids.include?(@a.id)}.from(false).to(true)
        expect{unarchive}.to change{@p.ad_lists.find_by(name: 'archived').ad_ids.include?(@a.id)}.from(true).to(false)
      end
    end

  end

end
