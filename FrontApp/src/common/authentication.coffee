do (app=angular.module "security", [
  'ui.router'
  'restangular'
]) ->
  app.factory('Auth', [
    'Restangular', '$state', '$window',
    (Restangular, $state, $window) ->
      new class Auth
        constructor: ->
          @currentUser = null

        getCurrentUser: ()->
          obj = @
          onSuccess = (success) ->
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
            @currentUser = null
            $state.go 'landing'
          Restangular.all('users').all('sign_out').customGET().then onSuccess
  ])

