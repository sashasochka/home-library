# 1. Books -- {
#   "name" : "Де, що і коли?", "author_surname" : "", "author_name" : "", "lang" : "Українська", "genre" : "Енциклопедія", "year" : 2007, "note" : "", "_id" : "PaTTHdb4sGkDWnguC" }

Meteor.publish 'books', ->
  Books.find()

Meteor.methods
  addBook: (book) ->
    book.timestamp = new Date()
    Books.insert book
