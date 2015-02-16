do (app=angular.module "security", [
  'ui.router'
  'restangular'
  'analytics'
]) ->
  app.factory('Auth', [
    'Restangular', '$state', '$window', 'Analytics',
    (Restangular, $state, $window, Analytics) ->
      new class Auth
        constructor: ->
          @currentUser = null

        getCurrentUser: ()->
          obj = @
          onSuccess = (success) ->
            Analytics.registerUser( success.user )
            obj.currentUser = success.user
          onError = (error) ->
            console.log error
            false
          Restangular.one('users', 'me').get().then onSuccess, onError

        isAuthenticated: ->
          if @currentUser then true else false

        linkedinConnect: ->
          $window.location.href = '/users/auth/google_oauth2'

        logout: ->
          onSuccess = (success)->
            $state.go 'landing'
          Restangular.all('users').all('sign_out').customGET().then onSuccess
  ])

