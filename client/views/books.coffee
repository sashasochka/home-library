# Paginated list of books
_.extend Template['books'],
  books: ->
    # Logger.info 'Template.books.books'
    sort = {}
    sort[Session.get 'sort-by'] = Session.get 'sort-order'
    books = Books.find {},
      sort: sort
      limit: Session.get 'books-per-page'
    books.map (book) ->
      _.map([book.name, book.author_name, book.author_surname,
             book.lang, book.genre, book.year, book.note], (value, index) ->
        value: value,
        class: Template['table-header'].columns()[index].class)

  # True if books still loading
  loading: ->
    # Logger.info 'Handles.books is null: ', (Handles.books is null)
    not Handles.books?.ready()
