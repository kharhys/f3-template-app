{ authenticate } = require \feathers-authentication .hooks
{ NotAuthenticated } = require \feathers-errors

verifyIdentity = authenticate \jwt

hasToken = (hook) -> hook.params.headers.authorization or hook.data.accessToken

authenticate = (hook) ->
    try
        verifyIdentity hook .then (res) -> return res
        return
    catch error
        if error instanceof NotAuthenticated and not hasToken hook then return hook else throw error

module.exports = authenticate