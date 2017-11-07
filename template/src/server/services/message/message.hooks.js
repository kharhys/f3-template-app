const { authenticate } = require('feathers-authentication').hooks
const { setCreatedAt, setUpdatedAt } = require('feathers-hooks-common')

const isEnabled = require('~/hooks/is-enabled')
const ownerOrPermission = require('~/hooks/owner-or-permission')
const associateCurrentUser = require('~/hooks/associate-current-user')

export default {
  before: {
    all: [],
    find: [
    ],
    get: [
    ],
    create: [
      authenticate('jwt'),
      isEnabled(),
      setCreatedAt(),
      associateCurrentUser()
    ],
    update: [
      ...ownerOrPermission({ service: 'message', permission: 'manageMessages' }),
      setUpdatedAt()
    ],
    patch: [
      ...ownerOrPermission({ service: 'message', permission: 'manageMessages' }),
      setUpdatedAt()
    ],
    remove: [
      ...ownerOrPermission({ service: 'message', permission: 'manageMessages' })
    ]
  },
  after: {
    all: [],
    find: [],
    get: [],
    create: [],
    update: [],
    patch: [],
    remove: []
  },
  error: {
    all: [],
    find: [],
    get: [],
    create: [],
    update: [],
    patch: [],
    remove: []
  }
}
