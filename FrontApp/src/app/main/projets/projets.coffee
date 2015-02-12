do (app=angular.module "trouverDesTerrains.projets", [
  'ui.router'
  'restangular'
  'trouverDesTerrains.new'
  'trouverDesTerrains.listeProjets'
  'trouverDesTerrains.projetDetail'
]) ->

  app.factory 'Project', [
    ()->
      {}

  ]
