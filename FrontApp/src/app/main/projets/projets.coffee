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
            .one 'list', listId
            .customGET null

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

  ]
