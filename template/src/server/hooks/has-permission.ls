_ = require 'lodash'
errors = require 'feathers-errors'

module.exports = (permission) ->
  (hook) ->
    return hook if not hook.params.provider
    if (_.get hook, 'params.user.role') is 'admin' then return hook
    name = (_.get hook, 'params.user.name') or _.get hook, 'params.user.email'
    if not _.get hook, 'params.user'
      throw new errors.NotAuthenticated 'Cannot read user permissions. The current user is missing. You must not be authenticated.'
    else
      if not _.get hook, 'params.user.permissions'
        throw new errors.GeneralError name + ' does not have any permissions.'
      else
        if not hook.params.user.permissions.includes permission then throw new errors.Forbidden name + ' does not have permission to do that.'
    return 