capitalize = (str) ->
  str.charAt(0).toUpperCase() + str.slice(1);

NonEmptyString = Match.Where (x) ->
  check x, String
  x.length > 0

Meteor.methods
  'insert-book': (book) ->
    if @userId?
      check book.name, NonEmptyString
      check book.author_name, String
      check book.author_surname, String
      check book.lang, NonEmptyString
      check book.genre, NonEmptyString
      check book.year, Match.Integer
      check book.note, String
      book.timestamp = new Date().getTime()
      book.name = capitalize book.name
      book.genre = capitalize book.genre
      book.lang = capitalize book.lang
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
