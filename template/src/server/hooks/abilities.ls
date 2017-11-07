errors = require \feathers-errors
{Ability, AbilityBuilder, toMongoQuery} = require \casl

Ability.addAlias \update \patch
Ability.addAlias \remove \delete
Ability.addAlias \read <[get find]>

TYPE_KEY = Symbol.for \type
subject-name = (subject) -> if (not subject or typeof subject is \string) then subject else subject[TYPE_KEY]

define-abilities-for = (user) -> 
    {rules, can} = AbilityBuilder.extract!
    #can \read <[posts comments]>
    if user
        can \manage <[posts comments]> author: user._id
        can <[read update]> \users _id: user._id
    new Ability rules, subjectName: subject-name

Forbidden = errors.Forbidden
authorize = (name) ->
    name = if name then name else null
    (hook) ->
        action = hook.method
        serviceName = name or hook.path
        hook.params.ability = define-abilities-for hook.params.user
        service = if name then hook.app.service name else hook.service
        if not hook.id
            rules = hook.params.ability.rulesFor action, serviceName
            Object.assign hook.params.query, toMongoQuery rules
            return hook
        params = Object.assign {}, hook.params, provider: null
        (service.get hook.id, params).then (result) ->
            result[TYPE_KEY] = serviceName
            if hook.params.ability.cannot action, result then throw new Forbidden 'You are not allowed to ' + action + serviceName
            if action is 'get' then hook.result = result
            hook
        return

module.exports = authorize