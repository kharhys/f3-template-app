validatePattern = require '~/utils/validate-pattern'
schemas = require '~/schemas'

module.exports = (app) ->
  mongooseClient = app.get 'mongooseClient'
  Subscriber = new mongooseClient.Schema schemas.subscriber
  mongooseClient .model 'Subscriber', Subscriber