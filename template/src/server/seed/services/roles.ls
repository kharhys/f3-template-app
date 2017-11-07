admin =
  role: 'admin'
  permissions: <[ email create read update delete manageUsers manageMessages manageRoles manageSettings ]>

basic =
  role: 'basic'
  permissions: ['read']

module.exports = [admin, basic]