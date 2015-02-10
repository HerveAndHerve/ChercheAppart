$location = $scope = $rootScope = $state = {}

describe 'App Module', ()->
  beforeEach window.angular.mock.module 'trouverDesTerrains'

  describe 'router configuration', ()->
    beforeEach inject (_$location_, _$state_, _$rootScope_ ) ->
      $state = _$state_
      $location = _$location_
      $rootScope = _$rootScope_

    it 'Should redirect to the landing', () ->
      $location.path 'qsdq qdfqsdf qsdf qsd'
      $rootScope.$digest()
      expect( $state.current.url ).toBe '/landing'
