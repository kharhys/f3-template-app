_ = require 'lodash'
errors = require 'feathers-errors'
getItems = (require 'feathers-hooks-common').getItems

module.exports = (fieldToSet) ->
  fieldToSet = if fieldToSet then fieldToSet else 'userId'
  (hook) ->
    if not _.get hook, 'params.user._id'
      throw new errors.NotAuthenticated 'The current user is missing. You must not be authenticated.'
    (_.castArray getItems hook).forEach ((item) ->
      item[fieldToSet] = _.get hook, 'params.user._id'
      return )
    Promise.resolve hook