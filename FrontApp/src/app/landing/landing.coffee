do (app=angular.module "trouverDesTerrains.landing", [
  'ui.router'
  'templates'
  'security'
  'templates'
]) ->
  app.config ['$stateProvider', ($stateProvider) ->
    $stateProvider.state 'landing',
      url: '/landing'
      views:
        "main":
          controller: 'LandingController'
          templateUrl: '/app/landing/landing.html'
      data:
        pageTitle: 'Accueil'
  ]

  app.controller 'LandingController', [
    '$scope', 'Auth', '$window', '$state', '$document',
    ($scope, Auth, $window, $state, $document) ->

      $scope.Auth = Auth

      onSuccess = (success)->
        if success.id
          $state.go 'main.projects'
      Auth.getCurrentUser().then onSuccess

      $scope.authenticate = ()->
        $window.location.href = '/users/auth/google_oauth2'
  ]

