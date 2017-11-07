logger = require 'winston'
app = require '~/app'

process.on 'unhandledRejection', (reason, p) ->
  logger.error 'Unhandled Rejection at: Promise ', p, reason
  return

process.on 'nuxt:build:done', (err) ->
  logger.error err if err
  app.listen (app.get 'port'), (app.get 'host'), (err) ->
      throw err if err
      app.info 'app.listening on http://' + (app.get 'host') + ':' + (app.get 'port')
      return
  console.info '    nuxt:build:done '
  return
