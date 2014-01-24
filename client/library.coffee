booksHandle = Meteor.subscribe 'books', ->
  undefined

Session.setDefault 'current_page', 1
Session.setDefault 'books_per_page_limit', 20
Session.set 'number_of_pages', 1 #Math.ceil(Books.find().count() / Session.get('books_per_page_limit'))

Deps.autorun ->
  if booksHandle.ready()
    Session.set 'number_of_pages',
      Math.ceil(Books.find().count() / Session.get('books_per_page_limit'))

# Helper function for adding 'active' class to tags if condition holds
class_if = (className, bool_value) ->
  if bool_value then className else ''

# Paginated list of books
Template.books.books = ->
  limit = Session.get 'books_per_page_limit'
  page = Session.get 'current_page'
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
  _.map _.range(1, 1 + Session.get 'number_of_pages'), (page_number) ->
    page_number: page_number
    active_class: ->
      class_if 'active', page_number is Session.get 'current_page'

# Handle clicks on pagination
Template.pagination.events =
  'click .page_number': ->
    Session.set 'current_page', @page_number

# Set up
Template.pagination.active_previous_class = ->
  class_if 'disabled', (Session.get 'current_page') is 1

Template.pagination.active_next_class = ->
  class_if 'disabled', (Session.get 'current_page') is (Session.get 'number_of_pages')

#Meteor.Router.add
#  '/': '/'
#  '/news': 'news'
#  '/about': ->
#  '*': 'not_found'
