createService = require 'feathers-mongoose'

createModel = require '../../models/users.model'
filters = require './users.filters'
hooks = require './users.hooks'

module.exports = ->
  app = this
  Model = createModel app
  paginate = app.get 'paginate'
  options =
    name: 'User'
    Model: Model
    paginate: paginate
  app.use '/users', createService options
  service = app.service 'users'
  service.hooks hooks
  service.filter filters if service.filter
  return
