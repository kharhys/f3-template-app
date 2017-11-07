_ = require 'lodash'
errors = require 'feathers-errors'

defaults = idField: '_id' ownerField: 'userId'

module.exports = (options) ->
    (hook) ->
        throw new Error 'The "ownerOrRestrict" hook should only be used as a "before" hook.' if hook.type isnt 'before'
        if not hook.id
            throw new errors.MethodNotAllowed 'The "ownerOrRestrict" hook should only be used on the "get", "update", "patch" and "remove" service methods.'
        if not hook.params.provider then return hook
        if not hook.params.user
            throw new errors.NotAuthenticated 'The current user is missing. You must not be authenticated.'
        options = Object.assign {}, defaults, (hook.app.get 'auth'), options
        id = hook.params.user[options.idField]
        if id is void then throw new Error options.idField + ' is missing from current user."'
        new Promise ((resolve, reject) ->
            params = Object.assign {}, hook.params, {provider: void}
            ((@get hook.id, params).then ((data) ->
                if data.toJSON then data = data.toJSON! else if data.toObject then data = data.toObject!
                field = data[options.ownerField]
                if _.isPlainObject field then field = field[options.idField]
                if Array.isArray field
                    fieldArray = field.map ((idValue) -> idValue.toString!)
                    if fieldArray.length is 0 || (fieldArray.indexOf id.toString!) < 0
                        name = (_.get hook, 'params.user.name') || _.get hook, 'params.user.email'
                        options.restrictOn = _.castArray options.restrictOn
                        includeS = ''
                        restrictions = ((_.chain options.restrictOn).map ((restriction) -> 
                            if _.has hook.data, restriction then restriction else null)).compact!.value!.join ', '
                        return resolve hook if not restrictions
                        if (restrictions.split ',').length > 0
                            restrictions = restrictions.replace //,(?!.*,)//gim, ' or'
                            includeS = 's' if (restrictions.split ',').length > 1
                        throw new errors.Forbidden name + ' is not permitted to update the ' + restrictions + ' field' + includeS
                resolve hook
                return )).catch reject) 