# Paginated list of books
_.extend Template['books'],
  books: ->
    # Logger.info 'Template.books.books'
    sort = {}
    sort[Session.get 'sort-by'] = Session.get 'sort-order'
    books = Books.find {},
      sort: sort
      limit: Session.get 'books-per-page'

    book_values = (book) -> [
      book.name,
      book.author_name,
      book.author_surname,
      book.lang,
      book.genre,
      (book.year || ''), # if year is 0 then don't show it
      book.note
    ]

    add_css_classes = (values) ->
      _.map(values, (value, index) ->
        value: value,
        class: Template['table-header'].columns()[index].class)

    books.map (book) ->
      _.extend book,
        values: add_css_classes book_values book

  # True if books still loading
  loading: ->
    # Logger.info 'Handles.books is null: ', (Handles.books is null)
    not Handles.books?.ready()

  events:
    'click .remove-book-button': (evt) ->
      bootbox.confirm "Remove book with id=#{@_id}?", (positive_answer) =>
        if positive_answer
          Meteor.call 'remove-book', @_id
      evt.preventDefault()
    'click .edit-book-button': (evt) ->
      evt.preventDefault()
