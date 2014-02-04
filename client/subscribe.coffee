subscribe_error_logger = (collection_name) -> (err) ->
  Logger.error "Cannot subscribe to '#{collection_name}': #{err.reason}"

Deps.autorun ->
  if Meteor.userId()
    Handles.books_count = Meteor.subscribe 'books-count',
      search_query: Session.get 'search-query'
    ,
      onError: subscribe_error_logger 'books-count'
    Handles.genre_options = Meteor.subscribe 'genre-options',
      onError: subscribe_error_logger 'genre-options'
    Handles.lang_options = Meteor.subscribe 'lang-options',
      onError: subscribe_error_logger 'lang-options'
  else
    Handles.books_count = null
    Handles.genre_options = null
    Handles.lang_options = null

Deps.autorun ->
  if Meteor.userId()
    Handles.books = Meteor.subscribe 'books',
      page: Session.get 'current-page'
      page_size: Session.get 'books-per-page'
      sort_by: Session.get 'sort-by'
      sort_order: Session.get 'sort-order'
      search_query: Session.get 'search-query'
    ,
      onError: subscribe_error_logger 'books'
  else
    Handles.books = null

Deps.autorun ->
  if Meteor.userId() and Handles.books_count?.ready()
    Session.set 'number-of-pages',
      Math.ceil(BooksCount.findOne().count / Session.get('books-per-page'))
