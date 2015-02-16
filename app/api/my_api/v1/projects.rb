module MyApi
  module V1
    class Projects < Grape::API
      helpers MyApi::Helpers::ProjectsHelper
      format :json

      namespace :projects do 
        before do 
          sign_in!
        end

        #{{{ index (my projects)
        desc "get my list of projects"
        get do 
          present :projects, current_user.projects, with: MyApi::Entities::Project
        end
        #}}}

        #{{{ create
        desc "create a project"
        params do
          requires :name, type: String, desc: "the name of the project"
          optional :search_criteria, type: Hash do 
            optional :min_surface, desc: "in squared meters"
            optional :max_surface, desc: "in squared meters"
            optional :min_price  , desc: "in euros"
            optional :max_price  , desc: "in euros"
            optional :district   , desc: "Postal code. ex: 75012"
          end
        end
        post do 
          p = Project.new(
            name: params[:name],
          )

          if p.save
            p.owners << current_user
            unless params[:search_criteria].blank?
              h = ActionController::Parameters.new(params[:search_criteria]).permit([
                :min_surface,
                :max_surface,
                :min_price,
                :max_price,
                :district,
              ])
              p.search_criteria.update_attributes(h) or error!(@project.errors)
              present :project, p, with: MyApi::Entities::Project
            else
              error!(p.errors)
            end
          end
        end
        #}}}

        #{{{ claim
        desc "claim ownership of this project using a shareable token"
        params do
          requires :token, desc: "the shareable token"
        end
        get ':project_id/claim' do
          if p = Project.find(params[:project_id]) and current_user.claim_project!(p,params[:token])
            present :project, p, with: MyApi::Entities::Project
          else
            error!("wrong project_id/token combination",403)
          end
        end
        #}}}

        namespace ':project_id' do 
          before do 
            @project = current_user.projects.find(params[:project_id]) || error!("not found",404)
          end

          #{{{ shareable_token
          desc "get a shareable token to share ownership on this project"
          get :shareable_token do 
            present :token, @project.token
          end
          #}}}

          #{{{ get
          desc 'get project description'
          get do 
            present :project, @project, with: MyApi::Entities::Project
          end
          #}}}

          #{{{ update
          desc "update name, or search criteria"
          params do 
            optional :name, desc: "the project's name"
            optional :search_criteria, type: Hash do 
              optional :min_surface, desc: "in squared meters"
              optional :max_surface, desc: "in squared meters"
              optional :min_price  , desc: "in euros"
              optional :max_price  , desc: "in euros"
              optional :district   , desc: "Postal code. ex: 75012"
            end
          end
          put do 
            @project.update_attributes(name: params[:name]) unless params[:name].blank?
            unless params[:search_criteria].blank?
              p = ActionController::Parameters.new(params[:search_criteria]).permit([
                :min_surface,
                :max_surface,
                :min_price,
                :max_price,
                :district,
              ])
              @project.search_criteria.update_attributes(p)
            end

            present :project, @project, with: MyApi::Entities::Project
          end
          #}}}

          namespace :ads do 

            #{{{ ads index
            desc "get a project new ads"
            params do 
              optional :nstart, type: Integer, default: 0, desc: "first ad to show (default 0 for first ad)"
              optional :nstop, type: Integer, default: 9, desc: "last ad to show (default 9 for tenth ad)"
            end
            get :new do 
              count = @project.new_ads_count
              ads = @project.new_ads[params[:nstart]..params[:nstop]]

              present :total_count, count
              present :ads, ads, with: MyApi::Entities::Ad
            end
            #}}}

            #{{{ archived
            desc "see my archived list"
            params do 
              optional :nstart, type: Integer, default: 0, desc: "first ad to show (default 0 for first ad)"
              optional :nstop, type: Integer, default: 10, desc: "last ad to show (default 9 for tenth ad)"
            end
            get :archived do
              arc = @project.ad_lists.find_or_create_by(name: "archivé").ads
              count = arc.size
              present :total_count, count
              present :ads, arc[params[:nstart]..params[:nstop]], with: MyApi::Entities::Ad
            end
            #}}}

            namespace ':ad_id' do
              before do
                @ad = Ad.find(params[:ad_id]) || error!("ad not found",404)
                params do 
                  requires :ad_id, desc: "the id of the ad"
                end
              end

              #{{{ add to list
              desc "add an ad to a project's list"
              params do 
                requires :list_name_or_id, desc: "either the id of the list, or a name"
              end
              post :enlist do 
                try_if_authorized { current_user.enlist_ad!(@project, @ad, params[:list_name_or_id]) }
              end
              #}}}

              #{{{ remove from list
              desc "remove an ad from a list"
              params do 
                requires :list_name_or_id, desc: "either the id of the list, or a name"
              end
              post :unlist do 
                try_if_authorized { current_user.unlist_ad!(@project, @ad, params[:list_name_or_id]) }
              end
              #}}}

              #{{{ archive
              desc "archive this ad"
              post :archive do
                try_if_authorized { current_user.enlist_ad!(@project, @ad,'archivé') }
              end
              #}}}

              #{{{ unarchive
              desc "unarchive this ad"
              post :unarchive do
                try_if_authorized { current_user.unlist_ad!(@project, @ad,'archivé') }
              end
              #}}}

            end

          end

          namespace 'lists' do 

            #{{{ index lists
            desc "get an index of this project's lists"
            get do 
              lists = @project.public_ad_lists
              present :lists, lists, with: MyApi::Entities::AdList
            end
            #}}}

            namespace ':list_id' do 
              before do 
                @list = @project.public_ad_lists.find(params[:list_id]) || error!("not found",404)
              end

              #{{{ delete list
              desc "delete a list"
              delete do 
                @list.destroy
                present :status, :destroyed
              end
              #}}}

              #{{{ update
              desc "updates a list name"
              params do 
                requires :name, desc: "new list name"
              end
              put do 
                if @list.update_attributes(name: params[:name])
                  present :list, @list, with: MyApi::Entities::AdList
                  present :status, :changed
                else
                  error!(@list.errors)
                end
              end
              #}}}

              #{{{ ads
              desc "get the ads of this list"
              params do 
                optional :nstart, type: Integer, default: 0, desc: "first ad to show (default 0 for first ad)"
                optional :nstop, type: Integer, default: -1, desc: "last ad to show (default -1 to show everything)"
              end
              get :ads do 
                present :list_name, @list.name
                present :total_count, @list.ads.count
                present :ads, @list.ads[params[:nstart]..params[:nstop]], with: MyApi::Entities::Ad
              end
              #}}}

            end
          end

        end

      end

    end
  end
end
