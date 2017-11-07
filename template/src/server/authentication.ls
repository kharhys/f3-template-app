_ = require 'lodash'
errors = require 'feathers-errors'
jwt = require 'feathers-authentication-jwt'
local = require 'feathers-authentication-local'
oauth2 = require 'feathers-authentication-oauth2'
authentication = require 'feathers-authentication'

module.exports = ->
  app = this
  config = app.get 'authentication'
  app.configure authentication config
  app.configure jwt!
  app.configure local config.local
  app.configure oauth2 Object.assign name: 'google' Strategy: (require 'passport-google-oauth20') , config.google
  app.configure oauth2 Object.assign name: 'facebook' Strategy: (require 'passport-facebook'), config.facebook
  app.configure oauth2 Object.assign name: 'github' Strategy: (require 'passport-github'), config.github
  (app.service 'authentication').hooks {
    before:
      create: [authentication.hooks.authenticate config.strategies]
      remove: [authentication.hooks.authenticate 'jwt']
#    after:
#        create: [
#            (hook) ->
#                return Promise.reject new errors.Forbidden 'Credentials incorrect' if not _.get hook, 'params.user'
#                hook.result.user = hook.params.user
#                delete! hook.result.user.password
#        ]
  }
