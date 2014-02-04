# if the database is empty on server start, export some default data

Meteor.startup ->
  # export default set of books if available
  if not Books.findOne()? and export_books?
    t = Date.now()
    _.each export_books, (book) ->
      delete book.id
      book.timestamp = t
      Books.insert book
      ++t

  # export list of allowed users if available
  if not AllowedUsers.findOne()? and allowed_emails?
    _.each allowed_emails, (email) ->
      AllowedUsers.insert {email}
