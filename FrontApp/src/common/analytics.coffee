do (app=angular.module "analytics", [
  'restangular'
]) ->
  app.run [
    'Restangular', '$rootScope', 'Analytics',
    (Restangular, $rootScope, Analytics)->
      onSuccess = (success)->
        mixpanel.init( success.token )
        $rootScope.mixpanel = true

      Restangular
        .all 'analytics/mixpanel'
        .customGET null
        .then onSuccess
  ]

  app.factory 'Analytics', [
    'Restangular', '$rootScope',
    (Restangular, $rootScope) ->
      new class Analytics
        registerUser: (user)->
          mixpanel.identify( user.id )
          mixpanel.people.set( name: user.name )

        projectCreated: ()->
          mixpanel.track 'project created'

        projectUpdated: ()->
          mixpanel.track 'project updated'

        addAdToList: ()->
          mixpanel.track 'ad moved to list'

        archiveAd: ()->
          mixpanel.track 'archive'

        navLists: ()->
          mixpanel.track 'select list'

        selectAd: ()->
          mixpanel.track 'select ad'
  ]
