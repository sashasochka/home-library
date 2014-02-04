capitalize = (str) ->
  str.charAt(0).toUpperCase() + str.slice(1);

NonEmptyString = Match.Where (x) ->
  check x, String
  x.length > 0

ValidBook =
  name: NonEmptyString
  author_name: String
  author_surname: String
  lang: NonEmptyString
  genre: NonEmptyString
  year: Match.Integer
  note: String

capitalize_fields = (book) ->
  book.name = capitalize book.name
  book.genre = capitalize book.genre
  book.lang = capitalize book.lang
  return

Meteor.methods
  'insert-book': (book) ->
    if @userId?
      check book, ValidBook
      capitalize_fields book
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
