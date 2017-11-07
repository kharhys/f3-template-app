validatePattern = require '~/utils/validate-pattern'

schemas = require '~/schemas'

module.exports = (app) ->
  mongooseClient = app.get 'mongooseClient'
  message = new mongooseClient.Schema schemas.message
  mongooseClient.model 'message', message