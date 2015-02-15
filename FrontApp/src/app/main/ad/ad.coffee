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
        resolve:
          ad: [
            'ProjectResource', '$stateParams',
            (ProjectResource, $stateParams)->
              ProjectResource.getAd( $stateParams.adId )
          ]

      .state 'main.project.categories.category.ad',
        url: '/ad/:adId'
        views:
          "main@":
            controller: 'AdController'
            templateUrl: '/app/main/ad/ad.html'
        data:
          pageTitle: 'ad/ad.tpl.html'
        resolve:
          ad: [
            'ProjectResource', '$stateParams',
            (ProjectResource, $stateParams)->
              ProjectResource.getAd( $stateParams.adId )
          ]

      .state 'main.project.archived.ad',
        url: '/ad/:adId'
        views:
          "main@":
            controller: 'AdController'
            templateUrl: '/app/main/ad/ad.html'
        data:
          pageTitle: 'ad/ad.tpl.html'
        resolve:
          ad: [
            'ProjectResource', '$stateParams',
            (ProjectResource, $stateParams)->
              ProjectResource.getAd( $stateParams.adId )
          ]
  ]

  app.controller 'AdController', [
    '$scope', '$stateParams', 'ListPicker', 'ad', 'ProjectResource', '$state',
    ($scope, $stateParams, ListPicker, ad, ProjectResource, $state) ->
      $scope.ad = ad
      $scope.archiveAd = ()->
        ProjectResource.archiveAd($stateParams.projectId, $stateParams.adId)
        $state.go '^', null, reload: true
      $scope.openMoveAdModal = (event)->
        onSuccess = ()->
          $state.go '^'
        ListPicker.openMoveAdModal(id: $stateParams.adId, event).then onSuccess

      $scope.$stateParams = $stateParams
  ]
