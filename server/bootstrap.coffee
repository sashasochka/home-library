# if the database is empty on server start, export some default data

Meteor.startup ->
  if Books.find().count() is 0
    t = new Date().getTime()
    _.each exportedBooksData, (book) ->
      delete book.id
      book.timestamp = t
      Books.insert book
      ++t
