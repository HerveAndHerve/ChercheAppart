do (app=angular.module "analytics", [
  'restangular'
]) ->
  app.factory('Analytics', [
    'Restangular',
    (Restangular)->
      ()->
        new class Analytics
  ]
