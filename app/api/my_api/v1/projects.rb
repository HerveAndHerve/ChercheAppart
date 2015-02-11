module MyApi
  module V1
    class Projects < Grape::API
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

        namespace ':project_id' do 
          before do 
            @project = current_user.projects.find(params[:project_id]) || error!("not found",404)
          end

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
              optional :nstop, type: Integer, default: 10, desc: "last ad to show (default 9 for tenth ad)"
            end
            get :new do 
              count = @project.new_ads_count
              ads = @project.new_ads[params[:nstart]..params[:nstop]]

              present :total_count, count
              present :ads, ads, with: MyApi::Entities::Ad
            end
            #}}}

          end

          namespace 'lists' do 

            #{{{ index lists
            desc "get an index of this project's lists"
            get do 
              lists = @project.ad_lists
              present :lists, lists, with: MyApi::Entities::AdList
            end
            #}}}

            namespace ':list_id' do 
              before do 
                @list = @project.ad_lists.find(params[:list_id]) || error!("not found",404)
              end

              #{{{ get an ad_list details
              get do 
                present :list, @list, with: MyApi::Entities::AdList, complete: true
              end
              #}}}

            end
          end

        end

      end

    end
  end
end
