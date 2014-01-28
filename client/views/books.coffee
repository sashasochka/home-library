# Paginated list of books
Template.books.books = ->
  # Logger.info 'Template.books.books'
  books = Books.find {},
    sort:
      timestamp: -1
    limit: Session.get 'books-per-page'
  books.map (book) ->
    _.map([book.name, "#{book.author_name} #{book.author_surname}",
           book.lang, book.genre, book.year, book.note], (value, index) ->
      value: value,
      class: Template.books.columns()[index].class)


# True if books still loading
Template.books.loading = ->
  # Logger.info 'Handles.books is null: ', (Handles.books is null)
  not Handles.books?.ready()

# List of columns in the table # with respective css classes
Template.books.columns = -> [
  class: 'col-name'
  title: 'Name'
,
  class: 'col-author'
  title: 'Author'
,
  class: 'col-language'
  title: 'Language'
,
  class: 'col-genre'
  title: 'Genre'
,
  class: 'col-year'
  title: 'Year'
,
  class: 'col-notes'
  title: 'Notes'
]
