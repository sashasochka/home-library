Meteor.Router.add
  '/': ->
    Session.set 'current-page', 1
  '/page/:page_number': (page_number) ->
    Session.set 'current-page', parseInt page_number
  '/sort-by/:sort_by/page/:page_number': (sort_by, page_number) ->
    Session.set 'current-page', parseInt page_number
    Session.set 'sort-by', sort_by
    # Session.set 'sort-order', (if sort_by in ['timestamp', 'year'] then -1 else 1)
    Session.set 'sort-order', -1
    Session.set 'current-sort-name',
      switch sort_by
        when 'timestamp' then 'creation date'
        when 'name' then 'name'
        when 'author_name' then 'author name'
        when 'author_surname' then 'author surname'
        when 'lang' then 'language'
        when 'genre' then 'genre'
        when 'year' then 'year'
        when 'note' then 'notes'
        else Logger.error 'invalid sort_by option during routing'
  '*': ->
    alert '404 Not found'
