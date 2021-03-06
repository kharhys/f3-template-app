_ = require 'lodash'
errors = require 'feathers-errors'

module.exports = (opts) ->
  options = if opts then opts else {}
  (hook) ->
    return Promise.resolve hook if not hook.params.provider
    if (_.get hook, 'params.user.role') is 'admin' then return Promise.resolve hook
    if (not _.get hook, 'params.user') or _.isEmpty hook.params.user
      throw new errors.NotAuthenticated 'Cannot check if the user is enabled. You must not be authenticated.'
    else
      if not _.get hook, 'params.user.isEnabled'
        name = (_.get hook, 'params.user.name') or _.get hook, 'params.user.email' or 'This user '
        throw new errors.Forbidden name + ' is disabled.'
    return 