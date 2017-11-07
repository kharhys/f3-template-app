createService = require 'feathers-mongoose'

createModel = require '../../models/roles.model'
filters = require './roles.filters'
hooks = require './roles.hooks'

module.exports = ->
  app = this
  Model = createModel app
  paginate = app.get 'paginate'
  options =
    name: 'roles'
    Model: Model
    paginate: paginate
  app.use '/roles', createService options
  service = app.service 'roles'
  service.hooks hooks
  service.filter filters if service.filter
  return 