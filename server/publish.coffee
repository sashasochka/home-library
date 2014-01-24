Books = new Meteor.Collection 'books'

Meteor.publish 'books', -> #(page, page_size) ->
  Books.find()

Meteor.publish 'books-count', ->
  count = 0 # the count of all users
  initializing = true # true only when we first start
  handle = Books.find().observeChanges
    added: =>
      count++ # Increment the count when users are added.
      @changed 'books-count', 1, {count} unless initializing
    removed: =>
      count-- # Decrement the count when users are removed.
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


Meteor.methods
  addBook: (book) ->
    book.timestamp = new Date()
    Books.insert book
