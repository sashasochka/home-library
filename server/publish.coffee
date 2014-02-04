checkLoggedIn = (subscriber) ->
  unless subscriber.userId?
    subscriber.error new Meteor.Error(HTTP.AccessDenied, 'user is not logged in')

is_value = (value) -> Match.Where (arg) ->
  arg is value

escape_regexp = (str) ->
  str.replace /[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&"

create_search_selector = (query) ->
  return {} unless query
  regexes = query.toLowerCase().compact().split(' ').map escape_regexp
  $and: regexes.map (regex) ->
    search_index:
      $regex: regex

Meteor.publish 'books', (options) ->
  # Logger.info 'meteor publish callback called: subscribed', [page,  page_size]
  checkLoggedIn @
  check options,
    page: Match.Integer
    page_size: Match.Integer
    sort_by: Match.Optional String
    sort_order: Match.Optional Match.OneOf(is_value(-1), is_value(1))
    search_query: Match.Optional String
  sort = {}
  # Logger.info 'Sort info', {sort_by,  sort_order}
  if options.sort_by? and options.sort_order?
    sort[options.sort_by] = options.sort_order
  else
    sort =
      timestamp: -1
  # Logger.info 'Sorting using: ', sort
  selector = create_search_selector options.search_query
  Books.find selector,
    limit: options.page_size
    skip: options.page_size * (options.page - 1)
    sort: sort

Meteor.publish 'books-count', (options) ->
  checkLoggedIn @
  check options, Match.Optional
    search_query: Match.Optional String
  count = 0 # the count of all books
  initializing = true # true only when we first start
  handle = Books.find(create_search_selector options?.search_query).observeChanges
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
