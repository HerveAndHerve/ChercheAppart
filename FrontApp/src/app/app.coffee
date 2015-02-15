do(app=angular.module 'templates', [])->

do (app=angular.module "trouverDesTerrains", [
  'ui.router'
  'ui.bootstrap'
  'ngMaterial'
  'templates'
  'siyfion.sfTypeahead'
  'security'
  'trouverDesTerrains.main'
  'trouverDesTerrains.landing'
  'trouverDesTerrains.projetDetail'
]) ->

  app.config ([
    '$mdThemingProvider',
    ($mdThemingProvider)->
      $mdThemingProvider.theme('default')
        .primaryColor('indigo')
        .accentColor('orange')
        .warnColor('pink')
  ])

  app.run([
    '$state', '$rootScope',
    ($state, $rootScope)->
      $rootScope.$on '$stateChangeError', (e, toS, toP, fS, fP, err)->
        console.log '------------------------'
        console.log '-- state change error --'
        console.log '------------------------'
        console.log 'event'
        console.log e
        console.log 'to state'
        console.log toS
        console.log 'to params'
        console.log toP
        console.log 'from state'
        console.log fS
        console.log 'from params'
        console.log fP
        console.log 'error'
        console.log err
  ])

  app.config [
    '$stateProvider', '$urlRouterProvider',
    ($stateProvider, $urlRouterProvider) ->
      $urlRouterProvider.when '/', '/projets'
      $urlRouterProvider.otherwise '/landing'
  ]

  app.controller 'AppController', [
    '$scope', '$mdSidenav', '$state', 'Auth',
    ($scope, $mdSidenav, $state, Auth) ->
      $scope.Auth = Auth
      $scope.$state = $state
      $scope.toggleLeftNav = ->
        $mdSidenav( 'sidenav-left' ).toggle()
  ]

  # Configuration block for Restangular, the service
  # used to communicate with the api
  app.config [
    "RestangularProvider"
    (RestangularProvider) ->
      toType = (obj) ->
        ({}).toString.call(obj).match(/\s([a-zA-Z]+)/)[1].toLowerCase()

      RestangularProvider
        .setBaseUrl("/api/")
        .setRequestSuffix("/?format=json").setDefaultHttpFields
          withCredentials: true
          cache: false
        .setDefaultHeaders "Content-Type": "application/json"
        .setFullRequestInterceptor
        (element, operation, route, url, headers, params, httpConfig) ->
          headers["content-type"] = "application/json"

          # find arrays in requests and transform 'key' into 'key[]'
          # so that rails can understand that the reuquets contains
          #an array
          angular.forEach params, (param, key) ->
            if toType(param) is "array"
              newParam = []
              angular.forEach param, (value, key) ->
                newParam[key] = value
                return

              params[key + "[]"] = newParam
              delete params[key]

              newParam = null
            return

          element: element
          params: params
          headers: headers
          httpConfig: httpConfig
  ]

