commonHooks = require 'feathers-hooks-common'
authenticate = (require 'feathers-authentication').hooks.authenticate

isEnabled = require '../../hooks/is-enabled'

isAction = ->
  args = Array.from arguments
  (hook) ->
    args.includes hook.data.action
    return

module.exports =
  before:
    all: []
    find: []
    get: []
#    create: [commonHooks.iff (isAction 'passwordChange', 'identityChange'), [(authenticate ['jwt', 'local']), isEnabled!]]
    create: [ (authenticate ['jwt', 'local']) ]
    update: []
    patch: []
    remove: []
  after:
    all: []
    find: []
    get: []
    create: []
    update: []
    patch: []
    remove: []
  error:
    all: []
    find: []
    get: []
    create: []
    update: []
    patch: []
    remove: []
