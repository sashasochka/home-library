# Create a client-side subscription for the count of users.
BooksCount = new Meteor.Collection 'books-count'
Books = new Meteor.Collection 'books'

booksCountHandle = Meteor.subscribe 'books-count'

booksHandle = Meteor.subscribe 'books', -> ## FIXME subscribe only to subset on the current page
  undefined

Session.setDefault 'current-page', 1
Session.setDefault 'books-per-page-limit', 13
Session.set 'number-of-pages', 1

Deps.autorun ->
  if booksCountHandle.ready()
    Session.set 'number-of-pages',
      Math.ceil(BooksCount.findOne().count / Session.get('books-per-page-limit'))

# Helper function for adding 'active' class to tags if condition holds
class_if = (class_name, bool_value) ->
  if bool_value then class_name else ''

# Paginated list of books
Template.books.books = ->
  limit = Session.get 'books-per-page-limit'
  page = Session.get 'current-page'
  Books.find {},
    sort:
      _id: 1
    limit: limit
    skip: limit * (page - 1)

# True if books still loading
Template.books.loading = ->
  not booksHandle.ready()

# List of book pages
Template.pagination.page = ->
  _.map _.range(1, 1 + Session.get 'number-of-pages'), (page_number) ->
    page_number: page_number
    active_class: ->
      class_if 'active', page_number is Session.get 'current-page'

# Handle clicks on pagination
Template.pagination.events =
  'click .page_number': ->
    Session.set 'current-page', @page_number

# Set up
Template.pagination.active_previous_class = ->
  class_if 'disabled', (Session.get 'current-page') is 1

Template.pagination.active_next_class = ->
  class_if 'disabled', (Session.get 'current-page') is (Session.get 'number-of-pages')

#Meteor.Router.add
#  '/': '/'
#  '/news': 'news'
#  '/about': ->
#  '*': 'not-found'
