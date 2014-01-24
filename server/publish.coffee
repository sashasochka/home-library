## FIXME subscribe only to subset
Meteor.publish 'books', -> # (page, page_size) ->
  Books.find()

Meteor.methods
  addBook: (book) ->
    book.timestamp = new Date()
    Books.insert book
