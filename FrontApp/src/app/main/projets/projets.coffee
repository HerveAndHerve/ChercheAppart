do (app=angular.module "trouverDesTerrains.projets", [
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

  app.factory 'ProjectResource', [
    'Restangular',
    (Restangular)->
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
          Restangular
            .all 'projects'
            .customPOST project

        putProject: (project)->
          Restangular
            .one 'projects', project.id
            .customPUT project

        getProjectLists: (projectId)->
          Restangular
            .one 'projects', projectId
            .customGET 'lists'

        getListAds: (projectId, listId)->
          Restangular
            .one 'projects', projectId
            .one 'lists', listId
            .customGET 'ads'

        getNewAds: (projectId)->
          Restangular
            .one 'projects', projectId
            .all 'ads'
            .customGET 'new'

        getArchivedAds: (projectId)->
          Restangular
            .one 'projects', projectId
            .all 'ads'
            .customGET 'archived'

        archiveAd: (projectId, adId)->
          Restangular
            .one 'projects', projectId
            .one 'ads', adId
            .customPOST null, 'archive'

        addAdToList: (projectId, listId, adId)->
          params =
            list_name_or_id: listId
          Restangular
            .one 'projects', projectId
            .one 'ads', adId
            .customPOST params, 'enlist'

        getAd: (adId)->
          Restangular
            .one 'my_ads', adId
            .customGET null
  ]
