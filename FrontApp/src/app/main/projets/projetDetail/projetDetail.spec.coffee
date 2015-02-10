$scope = $state = createController = {}

describe 'projetDetail section', ->
  beforeEach(module 'trouverDesTerrains.projetDetail')

  describe 'LandsListController', ->
    beforeEach inject ( $injector ) ->
      $state = $injector.get '$state'
      $rootScope = $injector.get '$rootScope'
      Project = $injector.get 'Project'
      $scope = $rootScope.$new()
      $controller = $injector.get '$controller'
      createController = ()->
        $controller 'LandsListController', $scope: $scope

    it 'should have $state in the $scope', ()->
      controller = createController()
      expect( $scope.$state ).toBe( $state )
