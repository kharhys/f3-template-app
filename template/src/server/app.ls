configuration = require 'feathers-configuration'
socketio = require 'feathers-socketio'
bodyParser = require 'body-parser'
cookieParser = require 'cookie-parser'
#favicon = require 'serve-favicon'
logger = require 'feathers-logger'
compress = require 'compression'
hooks = require 'feathers-hooks'
sync = require 'feathers-sync'
rest = require 'feathers-rest'
feathers = require 'feathers'
winston = require 'winston'
helmet = require 'helmet'
cors = require 'cors'
path = require 'path'

authentication = require '~/authentication'
middleware = require '~/middleware'
appHooks = require '~/app.hooks'
services = require '~/services'
mongoose = require '~/mongoose'
routes = require '~/routes'
#seed = require '~/seed' 


app = feathers!

app.configure configuration path.join __dirname, '.~/..'
app.configure logger winston
app.configure mongoose

app.configure hooks!
app.configure rest!
app.configure socketio!
app.configure sync db: (app.get 'mongodb'), collection: 'syncEvents'
app.configure authentication
app.configure services
#app.configure seed

app.use cors!
app.use helmet!
app.use compress!
app.use cookieParser!
app.use bodyParser.json!
app.use bodyParser.urlencoded extended: true
app.use '/static', feathers.static path.join __dirname, '../client/assets'

app.configure middleware #always last conf

app.hooks appHooks

module.exports = app
