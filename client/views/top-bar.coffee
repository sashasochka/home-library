sort_option = (field, name) ->
  url: "/sort-by/#{field}/page/#{Session.get 'current-page'}"
  option_name: name
  is_divider: false

divider =
  is_divider: true

ok_cancel_events = (selector, callbacks) ->
  ok = callbacks.ok or _.noop
  cancel = callbacks.cancel or _.noop
  events = {}
  events["keyup #{selector}, keydown #{selector}, focusout #{selector}"] = (evt) ->
    if evt.type is "keydown" and evt.which is 27
      # escape = cancel
      cancel.call this, evt
    # else if evt.type is "keyup" and evt.which is 13 or evt.type is "focusout"
      # blur/return/enter = ok/submit if non-empty
    else if evt.type is "keyup" or evt.type is "focusout"
      value = String(evt.target.value or "")
      if value
        ok.call this, value, evt
      else
        cancel.call this, evt
  events

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
    sort_option 'note', 'Notes'
  ]
  search_query: ->
    Session.get 'search-query'
  current_sort_name: ->
    Session.get 'current-sort-name'
  events:
    'click #add-book-button': ->
      Template['add-book-dialog'].show
        'default-genre': -> GenreOptions.findOne().option
        'default-year': -> Template['add-book-dialog']['max-year']()

_.extend Template['top-bar'].events, ok_cancel_events '#search-input',
  ok: (query) ->
    Session.set 'search-query', query
  cancel: ->
    Session.set 'search-query', undefined
