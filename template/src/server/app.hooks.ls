hooks = require 'feathers-hooks-common'
whenever = hooks.when

logger = require '~/hooks/logger'
#authorize = require '~/hooks/abilities'
authenticate = require '~/hooks/authenticate'

filter = (hook) -> (hook.params.provider and '/' + hook.path) isnt (hook.app.get 'authentication').path

stash = (options) -> 
  console.log 'app before hook setup', options
  return (context) ->
    # console.log 'app before hook instance', context

module.exports =
  before:
    all: [stash!]
    find: []
    get: []
    create: []
    update: []
    patch: []
    remove: []
  after:
    all: [logger!]
    find: []
    get: []
    create: []
    update: []
    patch: []
    remove: []
  error:
    all: [logger!]
    find: []
    get: []
    create: []
    update: []
    patch: []
    remove: []