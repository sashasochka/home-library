checkLoggedIn = (subscriber) ->
  unless subscriber.userId?
    subscriber.error new Meteor.Error(HTTP.AccessDenied, 'user is not logged in')

is_value = (value) -> Match.Where (arg) ->
  arg is value

Meteor.publish 'books', (page, page_size, sort_by, sort_order) ->
  # Logger.info 'meteor publish callback called: subscribed', [page,  page_size]
  checkLoggedIn @
  check page, Match.Integer
  check page_size, Match.Integer
  sort = {}
  # Logger.info 'Sort info', {sort_by,  sort_order}
  if sort_by? and sort_order?
    check sort_by, String
    check sort_order, Match.OneOf(is_value(-1), is_value(1))
    sort[sort_by] = sort_order
  else
    sort =
      timestamp: -1
  # Logger.info 'Sorting using: ', sort
  Books.find {},
    limit: page_size
    skip: page_size * (page - 1)
    sort: sort

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

get_sorted_used_values = (collection, field_name) ->
  _(collection.find().fetch())
  .pluck(field_name)
  .countBy()
  .pairs()
  .sortBy(1)
  .reverse()
  .pluck(0)
  .value()

lang_options = get_sorted_used_values Books, 'lang'

Meteor.publish 'lang-options', ->
  checkLoggedIn @

  _.each lang_options, (option, index) =>
    @added 'lang-options', index, {option}
  # Let the client know that the subscription is ready.
  @ready()

genre_options = get_sorted_used_values Books, 'genre'
Meteor.publish 'genre-options', ->
  checkLoggedIn @

  _.each genre_options, (option, index) =>
    @added 'genre-options', index, {option}
  # Let the client know that the subscription is ready.
  @ready()
