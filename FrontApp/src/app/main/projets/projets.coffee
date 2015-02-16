do (app=angular.module "trouverDesTerrains.projets", [
  'analytics'
  'ui.router'
  'restangular'
  'trouverDesTerrains.new'
  'trouverDesTerrains.listeProjets'
  'trouverDesTerrains.projetDetail'
]) ->

  app.factory 'Project', [
    'ProjectResource', '$state',
    (ProjectResource, $state)->
      new class Project
        constructor: ()->
          @project = {}

        loadProject: (projectId)->
          that = @
          onSuccess = (success)->
            that.project = success.project
          ProjectResource.getProject( projectId ).then onSuccess

        createProject: (project)->
          onSuccess = (success)->
            $state.go 'main.project.news', projectId: success.project.id
          onError = (error)->
            console.log error
          ProjectResource.postProject(project).then onSuccess

        updateProject: (project)->
          onSuccess = ()->
            $state.go 'main.project.news', null, reload: true
          ProjectResource.putProject(project).then onSuccess
  ]

  app.factory 'Ads', [
    'ProjectResource',
    (ProjectResource)->

      batchSize = 10
      new class Ads

        constructor: ()->
          @ads = []
          @listId = null
          @projectId = null
          @batchIndex = 0
          @total_count = 1000000

        initializeList: (listId, projectId)->
          @ads = []
          @listId = listId
          @projectId = projectId
          @batchIndex = 0
          @loadNextBatch()
          @loading = false

        fullyLoaded: ()->
          batchSize * @batchIndex >= @total_count

        loadNextBatch: ()->
          that = @
          if that.listId and that.projectId and not that.loading
            that.loading = true
            start = that.batchIndex * batchSize
            end = ((that.batchIndex + 1) * batchSize) - 1

            onSuccess = (success)->
              that.batchIndex += 1
              that.loading = false
              that.total_count = success.total_count
              if success.ads
                if success.ads.length
                  that.ads = that.ads.concat success.ads

            if that.listId == 'new'
              ProjectResource.getNewAds( that.projectId, start, end).then onSuccess
            else if that.listId == 'archived'
              ProjectResource.getArchivedAds( that.projectId, start, end ).then onSuccess
            else
              ProjectResource.getListAds( that.projectId, that.listId, start, end ).then onSuccess
  ]

  app.factory 'ProjectResource', [
    'Restangular', 'Analytics',
    (Restangular, Analytics)->
      new class ProjectResource

        getProject: (projectId)->
          Restangular
            .one 'projects', projectId
            .customGET null

        getProjects: ()->
          Restangular
            .all 'projects'
            .customGET null

        postProject: (project)->
          analyticsCb = (success)->
            Analytics.projectCreated()
            success
          Restangular
            .all 'projects'
            .customPOST project
            .then analyticsCb

        putProject: (project)->
          analyticsCb = (success)->
            Analytics.projectUpdated()
            success
          Restangular
            .one 'projects', project.id
            .customPUT project
            .then analyticsCb

        getProjectLists: (projectId)->
          Restangular
            .one 'projects', projectId
            .customGET 'lists'

        getListAds: (projectId, listId, start, end)->
          params =
            nstart: start
            nstop: end

          Restangular
            .one 'projects', projectId
            .one 'lists', listId
            .customGET 'ads', params

        getNewAds: (projectId, start, end)->
          params =
            nstart: start
            nstop: end
          Restangular
            .one 'projects', projectId
            .all 'ads'
            .customGET 'new', params

        getArchivedAds: (projectId, start, end)->
          params =
            nstart: start
            nstop: end
          Restangular
            .one 'projects', projectId
            .all 'ads'
            .customGET 'archived', params

        archiveAd: (projectId, adId)->
          analyticsCb = (success)->
            Analytics.archiveAd()
            success
          Restangular
            .one 'projects', projectId
            .one 'ads', adId
            .customPOST null, 'archive'

        addAdToList: (projectId, listId, adId)->
          params =
            list_name_or_id: listId
          analyticsCb = (success)->
            Analytics.addAdToList()
            success
          Restangular
            .one 'projects', projectId
            .one 'ads', adId
            .customPOST params, 'enlist'
            .then analyticsCb

        getAd: (adId)->
          Restangular
            .one 'my_ads', adId
            .customGET null
  ]
