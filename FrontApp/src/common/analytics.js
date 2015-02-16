do (app=angular.module "analytics", [
  'restangular'
]) ->
  app.run [
    'Restangular',
    (Restangular)->
      
      
  ]
  app.factory('Analytics', [
    'Restangular',
    (Restangular)->
      ()->
        new class Analytics
  ]
