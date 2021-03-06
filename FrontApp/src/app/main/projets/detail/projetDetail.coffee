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
          lists: [
            'Lists', '$stateParams',
            (Lists, $stateParams)->
              Lists.loadLists($stateParams.projectId)
          ]
          project: [
            'Project', '$stateParams'
            (Project, $stateParams)->
              Project.loadProject( $stateParams.projectId )
          ]

      .state 'main.project.news',
        url: '/news'
        views:
          "main@main":
            templateUrl: '/app/main/projets/detail/ads.html'
            controller: 'AdsController'
          "sidenav@main":
            templateUrl: '/app/main/projets/detail/sidenav.html'
            controller: 'ListsSidenavController'

        resolve:
          ads: [
            'Ads', '$stateParams',
            (Ads, $stateParams)->
              Ads.initializeList( 'new', $stateParams.projectId )
          ]

      .state 'main.project.archived',
        url: '/archives'
        views:
          "main@main":
            templateUrl: '/app/main/projets/detail/ads.html'
            controller: 'AdsController'
          "sidenav@main":
            templateUrl: '/app/main/projets/detail/sidenav.html'
            controller: 'ListsSidenavController'
        resolve:
          ads: [
            'Ads', '$stateParams',
            (Ads, $stateParams)->
              Ads.initializeList( 'archived', $stateParams.projectId )
          ]

      .state 'main.project.list',
        url: '/:listId'
        views:
          'main@main':
            templateUrl: '/app/main/projets/detail/ads.html'
            controller: 'AdsController'
          "sidenav@main":
            templateUrl: '/app/main/projets/detail/sidenav.html'
            controller: 'ListsSidenavController'
        resolve:
          ads: [
            'Ads', '$stateParams',
            (Ads, $stateParams)->
              Ads.initializeList( $stateParams.listId, $stateParams.projectId )
          ]
  ]

  app.controller 'ListsSidenavController', [
    '$state', '$scope', 'Lists', 'Project', '$stateParams', 'Analytics', '$mdSidenav',
    ($state, $scope, Lists, Project, $stateParams, Analytics, $mdSidenav)->
      $scope.Project = Project
      $scope.$stateParams = $stateParams
      $scope.$state = $state
      $scope.Lists = Lists

      $scope.selectNews = ()->
        $mdSidenav('sidenav-left').toggle().then( ()->
          $state.go 'main.project.news'
        )
        Analytics.navLists()

      $scope.selectList = (list)->
        $mdSidenav('sidenav-left').toggle().then( ()->
          $state.go 'main.project.list', listId: list.id
        )
        Analytics.navLists()

  ]


  app.controller 'AdsController', [
    '$scope', 'ads', '$state', '$stateParams', 'ProjectResource', 'ListPicker', 'Lists', 'Project', 'Ads', 'Analytics',
    ($scope, ads, $state, $stateParams, ProjectResource, ListPicker, Lists, Project, Ads, Analytics) ->

      $scope.Ads = Ads
      $scope.Lists = Lists
      $scope.Project = Project

      $scope.$state = $state
      $scope.$stateParams = $stateParams

      $scope.selectAd = (ad)->
        Analytics.selectAd()
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
              ad: [
                ()->
                  ad
              ]
            targetEvent: event
          ).then (answer)->
  ]

  app.factory 'Lists', [
    'ProjectResource', '$stateParams', '$state', '$mdDialog', 'Project', '$mdSidenav'
    (ProjectResource, $stateParams, $state, $mdDialog, Project, $mdSidenav)->
      findListById = (lists, id)->
        out = null
        angular.forEach( lists, (list)->
          if list.id == id
            out = list
        )
        out

      new class Lists
        constructor: ()->
          @lists = []

        activeList: ()->
          if $state.current.name == 'main.project.news'
            name: 'Nouvelles annonces'
          else if $state.current.name == 'main.project.archived'
            name: 'Annonces archivées'
          else
            findListById( @lists, $stateParams.listId )

        addToList: (fromListId, toListId, adId)->
          if fromListId
            findListById( @lists, fromListId ).ads_count -= 1
          else if $state.current.name = "main.project.news"
            Project.project.new_ads_count -= 1
          else if $state.current.name = "main.project.archived"
            Project.project.archived_ads_count -= 1

          findListById( @lists, toListId ).ads_count += 1

          ProjectResource.addAdToList(
            $stateParams.projectId
            toListId
            adId
          )
          $mdDialog.hide()

        loadLists: ( projectId )->
          that = @
          onSuccess = (success)->
            that.lists = success.lists
          ProjectResource.getProjectLists(projectId).then onSuccess
  ]

  app.controller 'ListsDialogController', [
    '$scope', 'ProjectResource', '$stateParams', 'ad', '$mdDialog', 'Lists',
    ($scope, ProjectResource, $stateParams, ad, $mdDialog, Lists)->
      $scope.$stateParams = $stateParams
      $scope.lists = Lists.lists
      $scope.addAdToList = (list)->
        ad.hide = true
        Lists.addToList( $stateParams.listId, list.id, ad.id )
  ]
