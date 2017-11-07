nuxt = require './nuxt'

module.exports = ->
  app = this
  console.log 'nuxt middleware setup'
  app.use (req, res, next) ->
    console.log 'nuxt middleware pre render', req.user
    req.app = app
    req.app.cookie = req.headers.cookie
    nuxt.render req, res, next
  return
