smtpTransport = require 'nodemailer-smtp-transport'
Mailer = require 'feathers-mailer'

hooks = require './email.hooks'

module.exports = ->
  app = this
  paginate = app.get 'paginate'
  creds =
    user: app.get 'GMAIL'
    pass: app.get 'GMAIL_PASSWORD'
  conf = service: 'gmail' auth: creds
  mailer = Mailer smtpTransport conf
  #console.log mailer.transport
  app.use '/emails', mailer
  service = app.service 'emails'
  service.hooks hooks
  return
