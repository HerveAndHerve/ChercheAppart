do (app=angular.module "trouverDesTerrains.projets", [
  'ui.router'
  'restangular'
  'trouverDesTerrains.new'
  'trouverDesTerrains.listeProjets'
  'trouverDesTerrains.projetDetail'
]) ->

  app.config ['$stateProvider', ($stateProvider) ->
    $stateProvider.state 'main.projects',
      url: 'projets'
      abstract: true
  ]

  app.factory 'Project', [
    'ProjectResource', '$state', '$q', 'Land', '$stateParams', '$rootScope',
    (ProjectResource, $state, $q, Land, $stateParams, $rootScope )->

      # helper function
      projectIsLoaded = (projectId, projects)->
        out = null
        angular.forEach( projects, ( project )->
          if project.id == projectId
            out = project
        )
        out

      new class Project
        constructor: ()->
          @projects = []
          @projectsPromise = null

        createProject: (project)->
          that = @
          onSuccess = (success)->
            that.projects.push( success.project )
            $state.go 'main.projects.detail.new', projectId: success.project.id
          ProjectResource.postProject( project ).then onSuccess

        activeProject: ()->
          if $stateParams.projectId
            projectIsLoaded( $stateParams.projectId, @projects )
          else
            {}

        getProjects: ()->
          that = @
          onSuccess = (success)->
            that.projects = success.projects
          onError = (error)->
            console.log error
          if that.projects.length > 0
            $q.when that.projects
          else
            that.projectsPromise = $q.when( ProjectResource.myProjects().then onSuccess, onError )

        loadNewLands: (project)->
          project.lands = project.lands || []
          onSuccess = (success)->
            project.lands = project.lands.concat(success.new_lands.map((project)->
              project.status = 0
              project
            ))
          ProjectResource.getNewLands( project.id ).then onSuccess

        loadArchivedLands: (project)->
          project.lands = project.lands || []
          onSuccess = (success)->
            project.lands = project.lands.concat(success.archived_lands.map((project)->
              project.status = -1
              project
            ))
          ProjectResource.getArchivedLands( project.id ).then onSuccess

        loadFavouriteLands: (project)->
          project.lands = project.lands || []
          onSuccess = (success)->
            project.lands = project.lands.concat(success.favorite_lands.map((project)->
              project.status = 1
              project
            ))
          ProjectResource.getFavouriteLands( project.id ).then onSuccess

        loadLands: (projectId)->
          that = @
          if project = projectIsLoaded( projectId, @projects )
            project.lands = []
            promises = [
              $q.when @loadFavouriteLands( project )
              $q.when @loadArchivedLands( project )
              $q.when @loadNewLands( project )
            ]
            $q.all( promises )

          else
            onSuccess = (success)->
              if project = projectIsLoaded( projectId, that.projects )
                project.lands = []
                promises = [
                  $q.when that.loadFavouriteLands( project )
                  $q.when that.loadArchivedLands( project )
                  $q.when that.loadNewLands( project )
                ]
                $q.all( promises )
            @getProjects().then onSuccess


        archiveLand: (land, projectId )->
          onSuccess = (success)->
            land.status = -1
          Land.score( projectId, land.id, -1 ).then onSuccess

        favouriteLand: (land, projectId )->
          onSuccess = (success)->
            land.status = 1
          Land.score( projectId, land.id, 1 ).then onSuccess

        unSortLand: (land, projectId )->
          onSuccess = (success)->
            land.status = 0
          Land.score( projectId, land.id, 0 ).then onSuccess



  ]

  app.factory 'ProjectResource', [
    'Restangular', '$rootScope',
    (Restangular, $rootScope)->
      new class ProjectResource

        myProjects: ->
          Restangular
            .all 'projects'
            .customGET()

        getProject: (projectId)->
          Restangular
            .one 'projects', projectsId
            .get()

        postProject: (project)->
          params =
            town_id: project.town.id
            name: project.name
            min_surface: project.min_surface
            max_surface: project.max_surface
            max_distance: project.max_distance
          Restangular
            .all 'projects'
            .customPOST params

        townsTypeahead: (string)->
          Restangular
            .all 'towns'
            .customPOST query: string, 'typeahead'

        getArchivedLands: (projectId)->
          Restangular
            .one 'projects', projectId
            .all 'lands'
            .customGET 'archived'

        getNewLands: (projectId)->
          Restangular
            .one 'projects', projectId
            .all 'lands'
            .customGET 'new'

        getFavouriteLands: (projectId)->
          Restangular
            .one 'projects', projectId
            .all 'lands'
            .customGET 'favorite'
  ]

  app.factory 'Land', [
    'Restangular',
    (Restangular)->
      new class Land
        
        score: ( projectId, landId, score )->
          Restangular
            .one 'projects', projectId
            .one 'lands', landId
            .customPOST( score: score, 'score' )

  ]
