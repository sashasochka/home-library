Meteor.users.deny ->
  update: ->
    true

Accounts.validateNewUser (user) ->
  AllowedUsers.findOne({email: user.services.google.email})?
