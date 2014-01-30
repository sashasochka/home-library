Meteor.methods
  'insert-book': (book) ->
    if @userId?
      book.timestamp = new Date().getTime()
      Books.insert book
    else
      throw new Meteor.Error HTTP.AccessDenied, 'user is not logged in'
