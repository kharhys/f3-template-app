createService = require 'feathers-mongoose'

createModel = require '../../models/settings.model'
filters = require './settings.filters'
hooks = require './settings.hooks'

module.exports = ->
  app = this
  Model = createModel app
  paginate = app.get 'paginate'
  options =
    name: 'settings'
    Model: Model 
  app.use '/settings', createService options
  service = app.service 'settings'
  service.hooks hooks
  service.filter filters if service.filter
  return 