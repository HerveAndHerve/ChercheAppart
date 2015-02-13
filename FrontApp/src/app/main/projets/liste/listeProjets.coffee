do (app=angular.module "trouverDesTerrains.listeProjets", [
  'ui.router'
]) ->
  app.config ['$stateProvider', ($stateProvider) ->
    $stateProvider.state 'main.projects',
      url: '/projects'
      views:
        "main":
          controller: 'ListeProjetsController'
          templateUrl: '/app/main/projets/liste/listeProjets.html'
      data:
        pageTitle: 'mes projets'
      resolve:
        projects: [
          'ProjectResource',
          (ProjectResource)->
            ProjectResource.getProjects()
        ]
  ]

  app.controller 'ListeProjetsController', [
    '$scope', '$state', 'projects',
    ($scope, $state, projects) ->
      $scope.projects = projects.projects
      $scope.navToProject = (project)->
        $state.go 'main.project.news', projectId: project.id

  ]
