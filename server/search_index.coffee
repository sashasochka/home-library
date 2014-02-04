@search_index = (book) ->
  ("#{book.name} #{book.author_name} #{book.author_surname}" +
  "#{book.lang} #{book.genre} #{book.year} #{book.note}")
    .toLowerCase()
    .compact()
