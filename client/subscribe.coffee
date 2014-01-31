subscribe_error_logger = (collection_name) -> (err) ->
  Logger.error "Cannot subscribe to '#{collection_name}': #{err.reason}"

Deps.autorun ->
  if Meteor.userId()
    Handles.booksCount = Meteor.subscribe 'books-count',
      onError: subscribe_error_logger 'books-count'
  else
    Handles.booksCount = null

Deps.autorun ->
  if Meteor.userId()
    Handles.books = Meteor.subscribe 'books',
      Session.get('current-page'),
      Session.get('books-per-page'),
      onError: (err) ->
        Logger.error "Cannot subscribe to 'books': #{err.reason}"
  else
    Handles.books = null

Deps.autorun ->
  if Meteor.userId() and Handles.booksCount?.ready()
    Session.set 'number-of-pages',
      Math.ceil(BooksCount.findOne().count / Session.get('books-per-page'))