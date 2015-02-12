do (app=angular.module "trouverDesTerrains.listeProjets", [
  'ui.router'
]) ->
  app.config ['$stateProvider', ($stateProvider) ->
    $stateProvider.state 'main.projects',
      url: '/projects'
      views:
        "main":
          controller: 'ListeProjetsController'
          templateUrl: 'app/main/projets/liste/listeProjets.html'
      data:
        pageTitle: 'mes projets'
  ]

  app.controller 'ListeProjetsController', [
    '$scope', 'Project', '$state',
    ($scope, Project, $state) ->
      $scope.Project = Project
      $scope.navToProject = (project)->
        $state.go 'main.projects.detail.new', projectId: project.id

  ]
