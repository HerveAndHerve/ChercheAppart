$scope = $rootScope = $state = createController = Auth = $q = {}

describe 'landing module', ->
  beforeEach(module 'trouverDesTerrains.landing')

  describe 'Landing controller', ->
    beforeEach inject ( $injector ) ->
      $state = $injector.get '$state'
      $rootScope = $injector.get '$rootScope'
      $scope = $rootScope.$new()
      $controller = $injector.get '$controller'
      $q = $injector.get '$q'
      Auth = $injector.get 'Auth'

      createController = ()->
        $controller 'LandingController', $scope: $scope

      spyOn( $state, 'go' )


    it 'should call Auth.getCurrentUser and redirect to main.projects on success', ()->
      spyOn( Auth, 'getCurrentUser' ).andCallFake( ()->
        deferred = $q.defer()
        deferred.resolve(id: 1)
        deferred.promise
      )
      controller = createController()
      $rootScope.$digest()
      expect( Auth.getCurrentUser ).toHaveBeenCalled()
      expect( $state.go ).toHaveBeenCalledWith('main.projects')

    it 'should call Auth.getCurrentUser but not redirect to main.projects on fail', ()->
      spyOn( Auth, 'getCurrentUser' ).andCallFake( ()->
        deferred = $q.defer()
        deferred.reject()
        deferred.promise
      )
      controller = createController()
      $rootScope.$digest()
      expect( Auth.getCurrentUser ).toHaveBeenCalled()
      expect( $state.go ).not.toHaveBeenCalled()
