do (app=angular.module "trouverDesTerrains.projetDetail", [
  'ui.router'
  'trouverDesTerrains.projets'
]) ->

  app.config ['$stateProvider', ($stateProvider) ->
    $stateProvider
      .state 'main.project',
        url: '/project/:projectId'

      .state 'main.project.news',
        url: '/new'
        views:
          "main@main":
            templateUrl: 'app/main/projets/projetDetail/liste.html'
            controller: 'AdsController'

      .state 'main.project.archived',
        url: '/archives'
        views:
          "main@main":
            templateUrl: 'app/main/projets/projetDetail/liste.html'
            controller: 'AdsController'

      .state 'main.project.categories',
        url: '/categories'
        views:
          "main@main":
            templateUrl: 'app/main/projets/projetDetail/categories.html'
            controller: 'CategoriesController'

  ]

  app.controller 'AdsController', [
    '$scope', '$state', 'Project', '$stateParams', '$timeout',
    ($scope, $state, Project, $stateParams, $timeout) ->
      $scope.$state = $state
  ]

  app.controller 'CategoriesController', [
    '$scope',
    ($scope) ->
  ]

  app.filter 'reverse', [()->
    (items)->
      items.slice().reverse()
  ]
