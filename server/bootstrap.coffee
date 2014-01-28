# if the database is empty on server start, export some default data

Meteor.startup ->
  # export default set of books if available
  if not Books.findOne()? and export_books?
    t = new Date().getTime()
    _.each export_books, (book) ->
      delete book.id
      book.timestamp = t
      Books.insert book
      ++t
