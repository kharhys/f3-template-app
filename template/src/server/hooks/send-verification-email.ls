accountService = require '~/services/auth-management/notifier'

module.exports = (opts) ->
  options = if opts then opts else {}
  (hook) ->
    return hook if not hook.params.provider
    user = hook.result
    console.log('send verification email hook.result ', user)
    if (hook.app.get 'GMAIL') and hook.data and hook.data.email and user
      (accountService hook.app).notifier 'resendVerifySignup', user
      return hook
    hook
