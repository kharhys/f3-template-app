createService = require 'feathers-mongoose'

createModel = require '../../models/message.model'
filters = require './message.filters'
hooks = (require './message.hooks').default

module.exports = ->
  app = this
  Model = createModel app
  paginate = app.get 'paginate'
  options =
    name: 'message'
    Model: Model
    paginate: paginate
  app.use '/message', createService options
  service = app.service 'message'
  service.hooks hooks
  service.filter filters if service.filter
  return 