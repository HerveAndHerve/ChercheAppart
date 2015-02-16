$location = $scope = $rootScope = $state = Restangular = $q = {}

describe 'App Module', ()->
  beforeEach window.angular.mock.module 'trouverDesTerrains'

  describe 'router configuration', ()->
    beforeEach inject (_$location_, _$state_, _$rootScope_, _Restangular_, _$httpBackend_ ) ->
      $httpBackend = _$httpBackend_
      $state = _$state_
      $location = _$location_
      $rootScope = _$rootScope_
      console.log $httpBackend

      $httpBackend.whenGET('/api/analytics/mixpanel/?format=json').respond({})


    it 'Should redirect to the landing', () ->
      $location.path 'qsdfqsdfqsdf'
      $rootScope.$digest()
      expect( $state.current.views.main.controller ).toBe( 'LandingController' )


      
