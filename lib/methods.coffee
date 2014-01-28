Meteor.methods
  add_book: (book) ->
    book.timestamp = new Date().getTime()
    # Logger.info 'Book added', book
    Books.insert book
