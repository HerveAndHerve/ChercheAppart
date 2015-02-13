do (app=angular.module "trouverDesTerrains.ad", [
  'ui.router'
]) ->
  app.config ['$stateProvider', ($stateProvider) ->
    $stateProvider
      .state 'main.project.news.ad',
        url: '/ad/:adId'
        views:
          "main@":
            controller: 'AdController'
            templateUrl: '/app/main/ad/ad.html'
        data:
          pageTitle: 'ad/ad.tpl.html'

      .state 'main.project.categories.category.ad',
        url: '/ad/:adId'
        views:
          "main@":
            controller: 'AdController'
            templateUrl: '/app/main/ad/ad.html'
        data:
          pageTitle: 'ad/ad.tpl.html'

      .state 'main.project.archived.ad',
        url: '/ad/:adId'
        views:
          "main@":
            controller: 'AdController'
            templateUrl: '/app/main/ad/ad.html'
        data:
          pageTitle: 'ad/ad.tpl.html'
  ]

  app.controller 'AdController', [
    '$scope', '$stateParams', '$sce',
    ($scope, $stateParams, $sce) ->
      $scope.$stateParams = $stateParams
      $scope.url = $sce.trustAsResourceUrl(decodeURIComponent( $stateParams.adId ))
  ]
