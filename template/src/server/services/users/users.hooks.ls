_ = require('lodash')
commonHooks = require('feathers-hooks-common')
verifyHooks = require('feathers-authentication-management').hooks
authenticate = require('feathers-authentication').hooks.authenticate
restrictToOwner = require('feathers-authentication-hooks').restrictToOwner
hashPassword = require('feathers-authentication-local').hooks.hashPassword

isEnabled = require('~/hooks/is-enabled')
setDefaultRole = require('~/hooks/set-default-role')
setFirstUserToRole = require('~/hooks/set-first-user-to-role')
hasPermissionBoolean = require('~/hooks/has-permission-boolean')
preventDisabledAdmin = require('~/hooks/prevent-disabled-admin')
sendVerificationEmail = require('~/hooks/send-verification-email')

restrict = [
  authenticate('jwt'),
  isEnabled(),
  commonHooks.unless (hasPermissionBoolean 'manageUsers'), restrictToOwner idField: '_id' ownerField: '_id'
]

schema =
  include: [
    service: 'roles'
    nameAs: 'access'
    parentField: 'role'
    childField: 'role'
  ]

serializeSchema =
  computed:
    permissions: (item, hook) -> _.get(item, 'access.permissions')
  exclude: ['access', '_include']

module.exports =
  before:
    all: []
    find: [].concat(restrict),
    get: [].concat(restrict),
    create: [
      hashPassword(),
      verifyHooks.addVerification(),
      setDefaultRole(),
      setFirstUserToRole(role: 'admin'),
      preventDisabledAdmin()
    ]
    update: [
      commonHooks.disallow('external')
    ]
    patch: [
      preventDisabledAdmin(),
      commonHooks.iff(
        commonHooks.isProvider('external'),
        commonHooks.preventChanges(
          'email',
          'isVerified',
          'verifyToken',
          'verifyShortToken',
          'verifyExpires',
          'verifyChanges',
          'resetToken',
          'resetShortToken',
          'resetExpires'
        )
      ),
    ].concat(restrict),
    remove: [].concat(restrict)
  after:
    all: [
      commonHooks.when(
        (hook) -> hook.params.provider ,
        commonHooks.discard('password', '_computed', 'verifyExpires', 'resetExpires', 'verifyChanges')
      )
    ]
    find: [
      commonHooks.populate( schema: schema ),
      commonHooks.serialize(serializeSchema),
    ]
    get: [
      commonHooks.populate( schema: schema ),
      commonHooks.serialize(serializeSchema),
    ]
    create: [
      sendVerificationEmail(),
      verifyHooks.removeVerification()
    ]
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

