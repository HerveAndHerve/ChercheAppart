do (app=angular.module "trouverDesTerrains.new", [
  'ui.router'
]) ->
  app.config ['$stateProvider', ($stateProvider) ->
    $stateProvider.state 'main.projects.new',
      url: '/new'
      views:
        "main@main":
          controller: 'NewController'
          templateUrl: 'app/main/projets/new/new.html'
      data:
        pageTitle: 'Nouveau projet'
  ]

  app.controller 'NewController', [
    '$scope', 'Project', 'ProjectResource', '$q',
    ($scope, Project, ProjectResource, $q) ->
      $scope.project = {
      }

      $scope.townsTypeahead = (string)->
        onSuccess = (success)->
          $scope.loading = false
          $q.when(success.towns)
        if string.length > 2
          $scope.loading = true
          ProjectResource.townsTypeahead(string).then onSuccess

      $scope.createProject = ->
        Project.createProject $scope.project
  ]
