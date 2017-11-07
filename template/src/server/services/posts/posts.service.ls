createService = require 'feathers-mongoose'

createModel = require '../../models/posts.model'
filters = require './posts.filters'
hooks = require './posts.hooks'

module.exports = ->
  app = this
  Model = createModel app
  paginate = app.get 'paginate'
  options =
    name: 'Post'
    Model: Model
    paginate: paginate
  app.use '/posts', createService options
  service = app.service 'posts'
  service.hooks hooks
  service.filter filters if service.filter
  return 