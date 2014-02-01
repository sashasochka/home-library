Meteor.methods
  'insert-book': (book) ->
    if @userId?
      book.timestamp = new Date().getTime()
      Books.insert book
    else
      throw new Meteor.Error HTTP.AccessDenied, 'user is not logged in'
  'remove-book': (book_id) ->
    if @userId?
      # Logger.info "Removing book with id #{book_id}"
      Books.remove
        _id: book_id
    else
      throw new Meteor.Error HTTP.AccessDenied, 'user is not logged in'
