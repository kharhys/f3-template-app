authenticate = (require 'feathers-authentication').hooks.authenticate
common = require 'feathers-hooks-common'
errors = require 'feathers-errors'
_ = require 'lodash'

isEnabled = require './is-enabled'
isUserOwner = require './is-user-owner'
hasPermissionBoolean = require './has-permission-boolean'

module.exports = (opts) ->
  service = opts.service
  permission = opts.permission
  [
    authenticate 'jwt'
    isEnabled!
    common.unless (isUserOwner {service: service}), common.unless (hasPermissionBoolean permission), (hook) ->
      name = (_.get hook, 'params.user.name') || _.get hook, 'params.user.email'
      Promise.reject new errors.Forbidden name + ' is neither the owner nor has the permission to edit this message.'
  ]