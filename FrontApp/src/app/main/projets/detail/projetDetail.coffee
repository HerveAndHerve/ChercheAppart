do (app=angular.module "trouverDesTerrains.projetDetail", [
  'ui.router'
  'trouverDesTerrains.projets'
  'ngMaterial'
]) ->

  app.config ['$stateProvider', ($stateProvider) ->
    $stateProvider
      .state 'main.project',
        url: '/project/:projectId'
        resolve:
          categories: [
            'Lists', '$stateParams',
            (Lists, $stateParams)->
              Lists.loadLists($stateParams.projectId)
          ]
          project: [
            'ProjectResource', '$stateParams'
            (ProjectResource, $stateParams)->
              ProjectResource.getProjects( $stateParams.projectId )
          ]

      .state 'main.project.news',
        url: '/news'
        views:
          "main@main":
            templateUrl: '/app/main/projets/detail/ads.html'
            controller: 'AdsController'
          "sidenav@main":
            templateUrl: '/app/main/projets/detail/sidenav.html'
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
          "sidenav@main":
            templateUrl: '/app/main/projets/detail/sidenav.html'
            controller: 'AdsController'
        resolve:
          ads: [
            'ProjectResource', '$stateParams',
            (ProjectResource, $stateParams)->
              ProjectResource.getArchivedAds( $stateParams.projectId)
          ]

      .state 'main.project.category',
        url: '/:categoryId'
        views:
          'main@main':
            templateUrl: '/app/main/projets/detail/ads.html'
            controller: 'AdsController'
          "sidenav@main":
            templateUrl: '/app/main/projets/detail/sidenav.html'
            controller: 'AdsController'
        resolve:
          ads: [
            'ProjectResource', '$stateParams',
            (ProjectResource, $stateParams)->
              ProjectResource.getCategoryAds( $stateParams.projectId, $stateParams.categoryId )
          ]
  ]

  app.controller 'AdsController', [
    '$scope', 'ads', '$state', '$stateParams', 'ProjectResource', 'ListPicker', 'Lists', 'project',
    ($scope, ads, $state, $stateParams, ProjectResource, ListPicker, Lists, project) ->
      $scope.project = project.projects[0]
      $scope.$state = $state
      $scope.$stateParams = $stateParams
      $scope.ads = ads.ads
      $scope.Lists = Lists
      $scope.selectAd = (ad)->
        $state.go '.ad', projectId: $stateParams.projectId, adId: ad.id

      $scope.archiveAd = (ad)->
        ad.hide = true
        ProjectResource.archiveAd( $stateParams.projectId, ad.id )

      $scope.openMoveAdModal = (ad, event)->
        ListPicker.openMoveAdModal(ad, event)
  ]

  app.factory 'ListPicker', [
    '$mdDialog',
    ($mdDialog)->
      new class ListPicker
        openMoveAdModal: (ad, event)->
          $mdDialog.show(
            controller: 'ListsDialogController'
            templateUrl: '/app/main/projets/detail/listsDialog.html'
            resolve:
              lists: [
                'ProjectResource', '$stateParams',
                (ProjectResource, $stateParams)->
                  ProjectResource.getProjectLists($stateParams.projectId)
              ]
              ad: [
                ()->
                  ad
              ]
            targetEvent: event
          ).then (answer)->
  ]

  app.controller 'CategoriesController', [
    '$scope', 'categories', '$state', '$stateParams',
    ($scope, categories, $state, $stateParams) ->
      $scope.$stateParams = $stateParams
      $scope.categories = categories.lists
      $scope.selectCategory = (category)->
        $state.go 'main.project.categories.category', categoryId: category.id
        $scope.toggleLeftNav()
  ]

  app.factory 'Lists', [
    'ProjectResource', '$stateParams', '$state',
    (ProjectResource, $stateParams, $state)->
      new class Lists
        constructor: ()->
          @lists = []

        activeList: ()->
          if $state.current.name == 'main.project.news'
            name: 'Nouvelles annonces'
          else if $state.current.name == 'main.project.archived'
            name: 'Annonces archivées'
          else
            out = null
            angular.forEach( @lists, (list)->
              if list.id == $stateParams.categoryId
                out = list
            )
            out

        loadLists: ( projectId )->
          that = @
          onSuccess = (success)->
            that.lists = success.lists
          ProjectResource.getProjectLists(projectId).then onSuccess
  ]

  app.controller 'ListsDialogController', [
    'lists', '$scope', 'ProjectResource', '$stateParams', 'ad', '$mdDialog',
    (lists, $scope, ProjectResource, $stateParams, ad, $mdDialog)->
      $scope.$stateParams = $stateParams
      $scope.lists = lists.lists
      $scope.addAdToList = (list)->
        ad.hide = true
        ProjectResource.addAdToList(
          $stateParams.projectId
          list.id
          ad.id
        )
        $mdDialog.hide()
  ]

  app.directive 'resizable', [
    '$window',
    ($window)->
      ($scope)->
        $scope.initializeWindowSize = ->
          $scope.windowHeight = $window.innerHeight
          $scope.windowWidth  = $window.innerWidth
        $scope.initializeWindowSize()

        angular.element($window).bind 'resize', ->
          $scope.initializeWindowSize()
          $scope.$apply()
  ]

