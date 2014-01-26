# Create a client-side subscription for the count of users.
BooksCount = new Meteor.Collection 'books-count'

booksCountHandle = Meteor.subscribe 'books-count'
booksHandle = null

Session.setDefault 'current-page', 1
Session.setDefault 'books-per-page', 16
Session.set 'number-of-pages', 1

Meteor.Router.add
  '/': ->
    Session.set 'current-page', 1
  '/page/:page_number': (page_number) ->
    Session.set 'current-page', parseInt page_number
  '*': ->
    alert '404 Not found'

Deps.autorun ->
  # tb.info 'Deps autorun called'
  # tb.info 'current-page', Session.get 'current-page'
  booksHandle = Meteor.subscribe 'books',
    Session.get('current-page'),
    Session.get('books-per-page')
  if booksCountHandle.ready()
    Session.set 'number-of-pages',
      Math.ceil(BooksCount.findOne().count / Session.get('books-per-page'))

# Helper function for adding 'active' class to tags if condition holds
class_if = (class_name, bool_value) ->
  if bool_value then class_name else ''

Handlebars.registerHelper 'log', (context) ->
  console.log context

# Paginated list of books
Template.books.books = ->
  # tb.info 'meteor::books'
  limit = Session.get 'books-per-page'
  page = Session.get 'current-page'
  # tb.info 'Template books called', {limit, page}
  books = Books.find {},
    sort:
      timestamp: -1
    limit: Session.get 'books-per-page'
  books.map (book) ->
    _.map(
      [book.name, "#{book.author_name} #{book.author_surname}",
       book.lang, book.genre, book.year, book.note],
    (value, index) -> {value, class: Template.books.columns()[index].class})


# True if books still loading
Template.books.loading = ->
  # tb.info 'booksHandle is null: ', (booksHandle is null)
  not booksHandle.ready()


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

# List of book pages
Template.pagination.page = ->
  _.map _.range(1, 1 + Session.get 'number-of-pages'), (page_number) ->
    page_number: page_number
    active_class: ->
      class_if 'active', page_number is Session.get 'current-page'

Template.pagination.active_previous_class = ->
  class_if 'disabled', (Session.get 'current-page') is 1

Template.pagination.active_next_class = ->
  class_if 'disabled', (Session.get 'current-page') is (Session.get 'number-of-pages')

Template.pagination.previous_page_url = ->
  cur_page = parseInt Session.get 'current-page'
  if cur_page <= 2 then '/' else '/page/' + (cur_page - 1)

Template.pagination.next_page_url = ->
  cur_page = parseInt Session.get 'current-page'
  total_pages = parseInt Session.get 'number-of-pages'
  if cur_page == total_pages then '#' else '/page/' + (cur_page + 1)
