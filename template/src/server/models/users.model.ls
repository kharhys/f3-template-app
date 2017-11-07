validatePattern = require '~/utils/validate-pattern'

schemas = require '~/schemas'

colors = <[ #1ABC9C #16A085 #2ECC71 #27AE60 #3498DB #2980B9 #34495E #EA4C88 #CA2C68 #9B59B6 #8E44AD #F1C40F #F39C12 #E74C3C #C0392B ]>

module.exports = (app) ->
  mongooseClient = app.get 'mongooseClient'
  User = new mongooseClient.Schema schemas.user
  mongooseClient .model \User User