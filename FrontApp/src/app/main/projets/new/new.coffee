do (app=angular.module "trouverDesTerrains.new", [
  'ui.router'
]) ->
  app.config ['$stateProvider', ($stateProvider) ->
    $stateProvider.state 'main.newProject',
      url: '/projects/new'
      views:
        "main@main":
          controller: 'NewController'
          templateUrl: 'app/main/projets/new/new.html'
      data:
        pageTitle: 'Nouveau projet'
        action: 'create'
      resolve:
        project: ['$q', ($q)->
          Project = ()->
            @name = ''
            @search_criteria = {}
          $q.when(new Project)
        ]
  ]

  app.config ['$stateProvider', ($stateProvider) ->
    $stateProvider.state 'main.editProject',
      url: '/projects/:projectId/edit'
      views:
        "main@main":
          controller: 'NewController'
          templateUrl: 'app/main/projets/new/new.html'
      data:
        pageTitle: 'Nouveau projet'
        action: 'create'
      resolve:
        project: ['Project', '$stateParams', (Project, $stateParams)->
          Project.loadProject($stateParams.projectId)
        ]
  ]

  app.controller 'NewController', [
    '$scope', 'Project', '$state', 'project',
    ($scope, Project, $state, project) ->
      $scope.action = $state.current.data.action
      $scope.project = project
      $scope.createProject = ->
        Project.createProject $scope.project
  ]
