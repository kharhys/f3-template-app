const isProd = process.env.NODE_ENV === 'production'
const fs = require('fs')
const path = require('path')
const returnEmail = process.env.COMPLAINT_EMAIL
const pug = require('pug')

export default function(app) {


  const returnEmail = app.get('complaint_email') || process.env.COMPLAINT_EMAIL || 'support@tendapa.co.ke'

  function getLink(type, hash) {
    var url
    var port = (app.get('port') === '80' || isProd)? '': ':' + app.get('port')
    var host = (app.get('host') === 'HOST')? 'localhost': app.get('host')
    var protocal = (app.get('protocal') === 'PROTOCAL')? 'http': app.get('protocal')
    protocal += "://"
    return `${protocal}${host}${port}/login/${type}/${hash}`
  }

  function sendEmail(email) {
    return app.service('emails').create(email).then(function (result) {
      console.log('Sent email', result)
    }).catch(err => {
      console.log('Error sending email', err)
    })
  }

  return {
    notifier: function(type, user, notifierOptions) {
      console.log(`-- Preparing email for ${type}`, user)
      var hashLink
      var email
      var emailAccountTemplatesPath = path.join(app.get('src'), '..', 'src', 'server', 'email-templates', 'account')
      var templatePath
      var compiledHTML
      switch (type) {
        case 'resendVerifySignup': // send another email with link for verifying user's email addr

          hashLink = getLink('verify', user.verifyToken)

          templatePath = path.join(emailAccountTemplatesPath, 'verify-email.pug')

          compiledHTML = pug.compileFile(templatePath)({
            logo: '',
            name: user.name || user.email,
            hashLink,
            returnEmail
          })
          email = {
             from: app.get('GMAIL'),
             to: user.email,
             subject: 'Confirm Signup',
             html: compiledHTML
          }
//              console.log(email)
//          return sendEmail(email)

          break
        case 'verifySignup': // inform that user's email is now confirmed

          hashLink = getLink('verify', user.verifyToken)

          templatePath = path.join(emailAccountTemplatesPath, 'email-verified.pug')

          compiledHTML = pug.compileFile(templatePath)({
            logo: '',
            name: user.name || user.email,
            hashLink,
            returnEmail
          })

          email = {
             from: app.get('GMAIL'),
             to: user.email,
             subject: 'Thank you, your email has been verified',
             html: compiledHTML
          }

          return sendEmail(email)

          break
        case 'sendResetPwd': // inform that user's email is now confirmed

          hashLink = getLink('reset', user.resetToken)

          templatePath = path.join(emailAccountTemplatesPath, 'reset-password.pug')

          compiledHTML = pug.compileFile(templatePath)({
            logo: '',
            name: user.name || user.email,
            hashLink,
            returnEmail
          })

          email = {
             from: app.get('GMAIL'),
             to: user.email,
             subject: 'Reset Password',
             html: compiledHTML
          }

          return sendEmail(email)

          break
        case 'resetPwd': // inform that user's email is now confirmed

          hashLink = getLink('reset', user.resetToken)

          templatePath = path.join(emailAccountTemplatesPath, 'password-was-reset.pug')

          compiledHTML = pug.compileFile(templatePath)({
            logo: '',
            name: user.name || user.email,
            hashLink,
            returnEmail
          })

          email = {
             from: app.get('GMAIL'),
             to: user.email,
             subject: 'Your password was reset',
             html: compiledHTML
          }

          return sendEmail(email)

          break
        case 'passwordChange':

          templatePath = path.join(emailAccountTemplatesPath, 'password-change.pug')

          compiledHTML = pug.compileFile(templatePath)({
            logo: '',
            name: user.name || user.email,
            returnEmail
          })

          email = {
             from: app.get('GMAIL'),
             to: user.email,
             subject: 'Your password was changed',
             html: compiledHTML
          }

          return sendEmail(email)

          break
        case 'identityChange':
          hashLink = getLink('verifyChanges', user.verifyToken)

          templatePath = path.join(emailAccountTemplatesPath, 'identity-change.pug')

          compiledHTML = pug.compileFile(templatePath)({
            logo: '',
            name: user.name || user.email,
            hashLink,
            returnEmail,
            changes: user.verifyChanges
          })

          email = {
             from: app.get('GMAIL'),
             to: user.email,
             subject: 'Your account was changed. Please verify the changes',
             html: compiledHTML
          }

          return sendEmail(email)
          break
        default:
          break
      }
    }
  }
}
