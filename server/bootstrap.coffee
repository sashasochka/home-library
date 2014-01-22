# if the database is empty on server start, create some sample data.

Meteor.startup ->
  if Books.find().count() is 0
    _.each exportedBooksData, (book) ->
      Books.insert book

  if Lists.find().count() is 0
    timestamp = (new Date()).getTime()
    i = 0

    while i < data.length
      list_id = Lists.insert(name: data[i].name)
      j = 0

      while j < data[i].contents.length
        info = data[i].contents[j]
        Todos.insert
          list_id: list_id
          text: info[0]
          timestamp: timestamp
          tags: info.slice(1)

        ++timestamp # ensure unique timestamp.
        j++
      i++
