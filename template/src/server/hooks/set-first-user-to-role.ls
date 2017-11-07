_ = require 'lodash'
getItems = (require 'feathers-hooks-common').getItems

module.exports = (options) -> (hook) -> new Promise ( (resolve, reject) ->
    ((hook.app.service '/users').find {query: {}}).then ((found) ->
        console.log 'Checking if first user'
        found = found.data if (not Array.isArray found) && found.data
        if found.length is 0
            firstUser = (_.castArray getItems hook).0
            firstUser.role = options.role || 'admin'
            console.log 'set role to admin'
        resolve hook
        return ), (err) -> reject err )