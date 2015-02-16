describe MyApi::V1::Projects do 


  #{{{ index/show
  describe :index_and_show do 
    before do
      @project = FactoryGirl.create(:project)
    end
    subject(:index) { get '/api/projects' }
    subject(:get_project) { get "api/projects/#{@project.id}"}

    context 'when logged off' do 
      it "index requires login" do 
        index
        expect(response.status).to eq 401
      end
      it "index requires login" do 
        get_project
        expect(response.status).to eq 401
      end
    end

    context 'when logged in' do 
      before do 
        sign_up_and_login!
        @project.owners << @user
      end
      it "index shows my projects" do 
        index
        expect(parsed_response.has_key?("projects")).to be true
      end
      it "get shows my project" do 
        get_project
        expect(parsed_response.has_key?("project")).to be true
        expect(parsed_response["project"]["id"]).to eq @project.id.to_s
      end
    end

  end
  #}}}

  #{{{ create
  describe :create do
    before do 
      sign_up_and_login!
    end

    subject(:post_create) { post 'api/projects', {name: 'tagada', search_criteria: {min_surface: 12345}} }

    it 'creates project' do 
      expect{post_create}.to change{Project.count}.by(1)
    end

    it 'assigns project to current user' do
      post_create
      assert(Project.last.owners.include?(@user))
    end

    it 'fills search criteria' do
      post_create
      expect(Project.last.search_criteria.min_surface).to eq 12345
    end
  end
  #}}}

  #{{{ udpate
  describe :update do 
    before do
      sign_up_and_login!
      @project = FactoryGirl.build(:project)
      @project.owners << @user
      @project.save
      @user.save
      @user.reload
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

    subject(:update) { put "api/projects/#{@project.id}", ps ; @project.reload ; @project.search_criteria.reload }

    it 'update updates criteria' do 
      expect{update}.to change{@project.search_criteria.attributes.slice(*ps[:search_criteria].keys)}.to(ps[:search_criteria])
    end

    it 'update updates name' do 
      expect{update}.to change{@project.name}.to(ps[:name])
    end

  end


  #}}}

  #{{{ enlist
  describe :enlist_ad do 
    before do 
      sign_up_and_login!
      @p = FactoryGirl.build(:project)
      @p.owners << @user
      @a = FactoryGirl.build(:ad)
      @p.save
      @a.save
      @user.save
      allow_any_instance_of(User).to receive(:has_valid_subscription?).and_return(false)
    end

    subject(:enlist_with_new_name) { post "/api/projects/#{@p.id}/ads/#{@a.id}/enlist", {list_name_or_id: 'tagada'} ; @p.reload}
    subject(:enlist_with_existing_name) { post "/api/projects/#{@p.id}/ads/#{@a.id}/enlist", {list_name_or_id: 'intéressant'} ; @p.reload}
    subject(:enlist_with_id)  { post "/api/projects/#{@p.id}/ads/#{@a.id}/enlist", {list_name_or_id: @p.ad_lists.find_by(name: 'intéressant').id} ; @p.reload} 
    subject(:unlist_with_id)  { post "/api/projects/#{@p.id}/ads/#{@a.id}/unlist", {list_name_or_id: @p.ad_lists.find_by(name: 'intéressant').id} ; @p.reload} 
    subject(:archive) {post "/api/projects/#{@p.id}/ads/#{@a.id}/archive" ; @p.reload}
    subject(:unarchive) {post "/api/projects/#{@p.id}/ads/#{@a.id}/unarchive" ; @p.reload}

    context('when free moves are available') do
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
          expect{enlist_with_existing_name}.to change{@p.ad_lists.find_by(name: 'intéressant').ad_ids.include?(@a.id)}.from(false).to(true)
        end
      end

      describe 'enlist with id' do 
        it 'does NOT creates list' do 
          expect{enlist_with_id}.to change{@p.ad_lists.count}.by(0)
        end
        it 'adds the ad to the list' do 
          expect{enlist_with_id}.to change{@p.ad_lists.find_by(name: 'intéressant').ad_ids.include?(@a.id)}.from(false).to(true)
          expect{unlist_with_id}.to change{@p.ad_lists.find_by(name: 'intéressant').ad_ids.include?(@a.id)}.from(true).to(false)
        end
      end

      describe 'archive' do
        it 'archives' do
          expect{archive}.to change{@p.ad_lists.find_by(name: 'archivé').ad_ids.include?(@a.id)}.from(false).to(true)
          expect{unarchive}.to change{@p.ad_lists.find_by(name: 'archivé').ad_ids.include?(@a.id)}.from(true).to(false)
        end
      end

    end
    context("when no free moves are available") do
      before do 
        @user.update_attribute(:allowed_moves_count, 0)
      end

      it "won't archive" do
        archive
        expect(response.status).to eq 403
        expect(parsed_response["error"]).to eq "quota_excedeed"
      end

      it "won't enlist" do
        enlist_with_new_name
        expect(response.status).to eq 403
        expect(parsed_response["error"]).to eq "quota_excedeed"
      end

    end
  end
  #}}}

end
