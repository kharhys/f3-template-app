if not global.mongoose
  global.mongoose = require 'mongoose'
else
  bluebird = require 'bluebird'
  global.mongoose.Promise = bluebird

module.exports =
  subscriber: require '~/schemas/subscriber'
  settings: require '~/schemas/settings'
  message: require '~/schemas/message'
  roles: require '~/schemas/roles'
  user: require '~/schemas/user'