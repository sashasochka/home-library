subscribe_error_logger = (collection_name) -> (err) ->
  Logger.error "Cannot subscribe to '#{collection_name}': #{err.reason}"

Deps.autorun ->
  if Meteor.userId()
    Handles.booksCount = Meteor.subscribe 'books-count',
      onError: subscribe_error_logger 'books-count'
    Handles.genreOptions = Meteor.subscribe 'genre-options',
      onError: subscribe_error_logger 'genre-options'
    Handles.langOptions = Meteor.subscribe 'lang-options',
      onError: subscribe_error_logger 'lang-options'
  else
    Handles.booksCount = null
    Handles.genreOptions = null
    Handles.langOptions = null

Deps.autorun ->
  if Meteor.userId()
    Handles.books = Meteor.subscribe 'books',
      Session.get('current-page'),
      Session.get('books-per-page'),
      Session.get('sort-by'),
      Session.get('sort-order'),
      onError: subscribe_error_logger 'books'
  else
    Handles.books = null

Deps.autorun ->
  if Meteor.userId() and Handles.booksCount?.ready()
    Session.set 'number-of-pages',
      Math.ceil(BooksCount.findOne().count / Session.get('books-per-page'))
