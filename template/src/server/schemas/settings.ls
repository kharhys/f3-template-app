validatePattern = require '../utils/validate-pattern'

Schema = global.mongoose.Schema

module.exports =
  name:
    type: String
    trim: true
    required: true
    unique: true
    validate: validatePattern 'isTitle'
  value:
    type: Schema.Types.Mixed
    required: true