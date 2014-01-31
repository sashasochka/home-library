sort_option = (field, name) ->
  url: "/page/#{Session.get 'current-page'}/sort-by/#{field}"
  option_name: name
  is_divider: false

divider =
  is_divider: true

_.extend Template['top-bar'],
  sort_options: -> [
    sort_option 'timestamp', 'Creation date'
    sort_option 'name', 'Name'
    sort_option 'author_name', 'Author name'
    sort_option 'author_surname', 'Author surname'
    divider
    sort_option 'lang', 'Language'
    sort_option 'genre', 'Genre'
    sort_option 'year', 'Year'
    sort_option 'notes', 'Notes'
  ]
