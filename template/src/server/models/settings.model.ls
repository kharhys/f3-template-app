validatePattern = require '~/utils/validate-pattern'

schemas = require '~/schemas'

module.exports = (app) ->
  mongooseClient = app.get 'mongooseClient'
  settings = new mongooseClient.Schema schemas.settings
  mongooseClient.model 'settings', settings