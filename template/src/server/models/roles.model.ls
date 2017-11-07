validatePattern = require '~/utils/validate-pattern'

schemas = require '~/schemas'

sitePermissions = <[ email delete create update read manageUsers manageRoles manageSettings ]>

module.exports = (app) ->
  mongooseClient = app.get 'mongooseClient'
  roles = new mongooseClient.Schema schemas.roles
  mongooseClient.model 'roles', roles