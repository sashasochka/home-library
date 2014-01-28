Deps.autorun ->
  # Logger.info 'Deps autorun called'
  # Logger.info 'current-page', Session.get 'current-page'
  Handles.books = Meteor.subscribe 'books',
    Session.get('current-page'),
    Session.get('books-per-page')
  if Handles.booksCount.ready()
    Session.set 'number-of-pages',
      Math.ceil(BooksCount.findOne().count / Session.get('books-per-page'))
