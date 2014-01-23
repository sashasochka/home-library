# 1. Books -- {
#   "name" : "Де, що і коли?", "author_surname" : "", "author_name" : "", "lang" : "Українська", "genre" : "Енциклопедія", "year" : 2007, "note" : "", "_id" : "PaTTHdb4sGkDWnguC" }

Meteor.publish 'books', ->
  Books.find()


# 2. Publish complete set of lists to all clients.
#Meteor.publish 'lists', ->
#  Lists.find()


# 3. Publish all items for requested list_id.

# Todos -- {text: String,
#           done: Boolean,
#           tags: [String, ...],
#           list_id: String,
#           timestamp: Number}
#Meteor.publish 'todos', (list_id) ->
#  check list_id, String
#  Todos.find list_id: list_id
