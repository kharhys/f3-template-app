createService = require 'feathers-mongoose'

createModel = require '../../models/comments.model'
filters = require './comments.filters'
hooks = require './comments.hooks'

module.exports = ->
  app = this
  Model = createModel app
  paginate = app.get 'paginate'
  options =
    name: 'Comment'
    Model: Model
    paginate: paginate
  app.use '/comments', createService options
  service = app.service 'comments'
  service.hooks hooks
  service.filter filters if service.filter
  return 