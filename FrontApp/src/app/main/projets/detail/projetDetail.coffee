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
            templateUrl: '/app/main/projets/detail/ads.html'
            controller: 'AdsController'
        resolve:
          ads: [
            'ProjectResource', '$stateParams',
            (ProjectResource, $stateParams)->
              ProjectResource.getNewAds( $stateParams.projectId)
          ]

      .state 'main.project.archived',
        url: '/archives'
        views:
          "main@main":
            templateUrl: '/app/main/projets/detail/ads.html'
            controller: 'AdsController'
        resolve:
          ads: [
            'ProjectResource', '$stateParams',
            (ProjectResource, $stateParams)->
              ProjectResource.getArchivedAds( $stateParams.projectId)
          ]

      .state 'main.project.categories',
        url: '/categories'
        views:
          "main@main":
            templateUrl: '/app/main/projets/detail/categories.html'
            controller: 'CategoriesController'
        resolve:
          categories: [
            'ProjectResource', '$stateParams',
            (ProjectResource, $stateParams) ->
              ProjectResource.getProjectLists( $stateParams.projectId )
          ]

      .state 'main.project.categories.category',
        url: '/:categoryId'
        views:
          'main@main':
            templateUrl: '/app/main/projets/detail/ads.html'
            controller: 'AdsController'
        resolve:
          ads: [
            'ProjectResource', '$stateParams',
            (ProjectResource, $stateParams)->
              ProjectResource.getCategoryAds( $stateParams.projectId, $stateParams.categoryId )
          ]
  ]

  app.controller 'AdsController', [
    '$scope', 'ads', '$state', '$stateParams', 'ProjectResource',
    ($scope, ads, $state, $stateParams, ProjectResource) ->
      $scope.selectAd = (ad)->
        $state.go '.ad', projectId: $stateParams.projectId, adId: encodeURIComponent(ad.url)
      $scope.ads = ads.ads
      $scope.interestingAd = (ad)->
        ProjectResource.addAdToList( $stateParams.projectId, '54ddbf67416c65154a270000', ad.id )

        

  ]

  app.controller 'CategoriesController', [
    '$scope', 'categories', '$state',
    ($scope, categories, $state) ->
      $scope.categories = categories.lists
      $scope.selectCategory = (category)->
        $state.go 'main.project.categories.category', categoryId: category.id
  ]
