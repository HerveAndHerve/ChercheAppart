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
        createProject: (project)->
          onSuccess = (success)->
            $state.go 'main.project.new', projectId: success.id
          ProjectResource.postProject(project).then onSuccess
        
  ]

  app.factory 'ProjectResource', [
    'Restangular',
    (Restangular)->
      new class ProjectResource

        getProject: (projectId)->
          console.log 'haha'
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

        getProjectLists: (projectId)->
          Restangular
            .one 'projects', projectId
            .customGET 'lists'

        getCategoryAds: (projectId, listId)->
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
            .one 'ads', adId
            .customGET null
  ]
