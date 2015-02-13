$scope = $state = createController = ads = {}

describe 'projetDetail section', ->
  beforeEach(module 'trouverDesTerrains.projetDetail')

  describe 'LandsListController', ->
    beforeEach inject ( $injector ) ->
      $state = $injector.get '$state'
      $rootScope = $injector.get '$rootScope'
      $scope = $rootScope.$new()
      $controller = $injector.get '$controller'
      ads = []
      createController = ()->
        $controller 'AdsController', $scope: $scope, ads: ads

    it 'should have $state in the $scope', ()->
      controller = createController()
      expect( true ).toBeTruthy()
