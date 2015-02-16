do (app=angular.module "trouverDesTerrains.new", [
  'ui.router'
]) ->
  app.config ['$stateProvider', ($stateProvider) ->
    $stateProvider.state 'main.newProject',
      url: '/projects/new'
      views:
        "main@main":
          controller: 'NewController'
          templateUrl: '/app/main/projets/new/new.html'
      data:
        pageTitle: 'Nouveau projet'
        action: 'Créer le projet'
      resolve:
        project: ['$q', ($q)->
          Project = ()->
            @project =
              name: ''
              search_criteria: {}
          $q.when(new Project)
        ]
  ]

  app.config ['$stateProvider', ($stateProvider) ->
    $stateProvider.state 'main.project.edit',
      url: '/edit'
      views:
        "main@main":
          controller: 'EditController'
          templateUrl: '/app/main/projets/new/new.html'
        "sidenav@main":
          templateUrl: '/app/main/projets/detail/sidenav.html'
          controller: 'ListsSidenavController'
      data:
        pageTitle: 'Nouveau projet'
        action: 'Éditer le projet'
  ]

  app.controller 'NewController', [
    '$scope', 'Project', '$state', 'project',
    ($scope, Project, $state, project) ->
      $scope.action = $state.current.data.action
      console.log project
      $scope.project = project.project
      $scope.createProject = ()->
        Project.createProject $scope.project
  ]

  app.controller 'EditController', [
    '$scope', 'Project', '$state', 'project',
    ($scope, Project, $state, project) ->
      $scope.action = $state.current.data.action
      $scope.project = Project.project
      $scope.createProject = ()->
        Project.updateProject $scope.project
  ]
