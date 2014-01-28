Meteor.Router.add
  '/': ->
    Session.set 'current-page', 1
  '/page/:page_number': (page_number) ->
    Session.set 'current-page', parseInt page_number
  '*': ->
    alert '404 Not found'

