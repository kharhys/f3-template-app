_ = require 'lodash'
errors = require 'feathers-errors'

defaults = idField: '_id' ownerField: 'userId'

module.exports = (opts) ->
  options = if opts then opts else {}
  (hook) ->
    return Promise.resolve false if not hook.params.user
    options = Object.assign {}, defaults, (hook.app.get 'auth'), options
    id = hook.params.user[options.idField]
    if id is void then throw new Error options.idField + ' is missing from current user .'
    new Promise ((resolve, reject) ->
        params = Object.assign {}, hook.params, {provider: void}
        ((hook.service.get hook.id, params).then ((data) ->
            if data.toJSON then data = data.toJSON! else if data.toObject then data = data.toObject!
            field = data[options.ownerField]
            if _.isPlainObject field then field = field[options.idField]
            if Array.isArray field
                fieldArray = field.map ((idValue) -> idValue.toString!)
                return resolve false if fieldArray.length is 0 || (fieldArray.indexOf id.toString!) < 0
            else if field is void || field.toString! isnt id.toString! then return resolve false 
            resolve true
            return )).catch reject)