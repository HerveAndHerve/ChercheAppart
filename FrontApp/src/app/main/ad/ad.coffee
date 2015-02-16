do (app=angular.module "trouverDesTerrains.ad", [
  'ui.router'
]) ->
  app.config ['$stateProvider', ($stateProvider) ->
    $stateProvider
      .state 'main.project.news.ad',
        url: '/ad/:adId'
        views:
          "main@main":
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

      .state 'main.project.list.ad',
        url: '/ad/:adId'
        views:
          "main@main":
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
          "main@main":
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
    '$scope', '$stateParams', 'ListPicker', 'ad', 'ProjectResource', '$state', '$sce',
    ($scope, $stateParams, ListPicker, ad, ProjectResource, $state, $sce) ->
      $scope.ad = ad.ad

      $scope.trust = (url)->
        $sce.trustAsResourceUrl(url)

      $scope.archiveAd = ()->
        ProjectResource.archiveAd($stateParams.projectId, $stateParams.adId)
        $state.go '^', null, reload: true
      $scope.openMoveAdModal = (event)->
        onSuccess = ()->
          $state.go '^'
        ListPicker.openMoveAdModal(id: $stateParams.adId, event).then onSuccess

      $scope.$stateParams = $stateParams
  ]

  app.directive 'iframeResize', [
    ()->
      ($scope, elem, attr)->
        elem.on 'load', ()->
          height = elem[0].contentWindow.document.body.scrollHeight + 'px'
          widht = '100%'
          elem.css 'width', width
          elem.css 'height', height

  ]
