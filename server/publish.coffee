checkLoggedIn = (subscriber) ->
  unless subscriber.userId?
    subscriber.error new Meteor.Error(HTTP.AccessDenied, 'user is not logged in')

Meteor.publish 'books', (page, page_size) ->
  # Logger.info 'meteor publish callback called: subscribed', [page,  page_size]
  checkLoggedIn @
  check page, Match.Integer
  check page_size, Match.Integer
  Books.find {},
    limit: page_size
    skip: page_size * (page - 1)
    sort:
      timestamp: -1

Meteor.publish 'books-count', ->
  checkLoggedIn @
  count = 0 # the count of all books
  initializing = true # true only when we first start
  handle = Books.find().observeChanges
    added: =>
      ++count # Increment the count when books are added.
      @changed 'books-count', 1, {count} unless initializing
    removed: =>
      --count # Decrement the count when books are removed.
      @changed 'books-count', 1, {count}

  initializing = false

  # Call added now that we are done initializing. Use the id of 1 since
  # there is only ever one object in the collection.
  @added 'books-count', 1, {count}
  # Let the client know that the subscription is ready.
  @ready()

  # Stop the handle when the user disconnects or stops the subscription.
  # This is really important or you will get a memory leak.
  @onStop ->
    handle.stop()
