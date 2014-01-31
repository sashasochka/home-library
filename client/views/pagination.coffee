# Helper function for adding 'active' class to tags if condition holds
class_if = (class_name, bool_value) ->
  if bool_value then class_name else ''

# List of book pages
_.extend Template['pagination'],
  page: ->
    _.map _.range(1, 1 + Session.get 'number-of-pages'), (page_number) ->
      page_number: page_number
      active_class: ->
        class_if 'active', Session.equals('current-page', page_number)

  active_previous_class: ->
    class_if 'disabled', Session.equals('current-page', 1)

  active_next_class: ->
    class_if 'disabled', Session.equals('current-page', Session.get 'number-of-pages')

  previous_page_url: ->
    cur_page = parseInt Session.get 'current-page'
    if cur_page <= 2 then '/' else '/page/' + (cur_page - 1)

  next_page_url: ->
    cur_page = parseInt Session.get 'current-page'
    total_pages = parseInt Session.get 'number-of-pages'
    if cur_page == total_pages
    then '#' else '/page/' + (cur_page + 1)
