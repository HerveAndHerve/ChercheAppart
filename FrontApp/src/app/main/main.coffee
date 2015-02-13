do (app=angular.module "trouverDesTerrains.main", [
  'ui.router'
  'trouverDesTerrains.projets'
  'trouverDesTerrains.ad'
]) ->
  app.config ['$stateProvider', ($stateProvider) ->
    $stateProvider.state 'main',
      url: ''
      abstract: 'true'
      views:
        "main":
          controller: "MainController"
          templateUrl: 'app/main/main.html'
      data:
        pageTitle: 'main'

      resolve:
        authenticatedUser: ['Auth', '$state', (Auth, $state) ->
          onSuccess = (success) ->
            if success then success else onError()
          onError = (error) ->
            console.log error
            $state.go('landing')
          Auth.getCurrentUser().then onSuccess, onError
        ]
  ]

  app.controller 'MainController', [
    ()->
  ]
