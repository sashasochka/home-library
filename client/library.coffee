# ID of currently selected list
Session.setDefault 'list_id', null

# Name of currently selected tag for filtering
Session.setDefault 'tag_filter', null

# When adding tag to a todo, ID of the todo
Session.setDefault 'editing_addtag', null

# When editing a list name, ID of the list
Session.setDefault 'editing_listname', null

# When editing todo text, ID of the todo
Session.setDefault 'editing_itemname', null

# Subscribe to 'lists' collection on startup.
# Select a list once data has arrived.
listsHandle = Meteor.subscribe('lists', ->
  unless Session.get('list_id')
    list = Lists.findOne({},
      sort:
        name: 1
    )
    Router.setList list._id  if list
)
todosHandle = null

# Always be subscribed to the todos for the selected list.
Deps.autorun ->
  list_id = Session.get('list_id')
  if list_id
    todosHandle = Meteor.subscribe('todos', list_id)
  else
    todosHandle = null


######### Helpers for in-place editing ##########

# Returns an event map that handles the 'escape' and 'return' keys and
# 'blur' events on a text input (given by selector) and interprets them
# as 'ok' or 'cancel'.
okCancelEvents = (selector, callbacks) ->
  ok = callbacks.ok or ->

  cancel = callbacks.cancel or ->

  events = {}
  events['keyup ' + selector + ', keydown ' + selector + ', focusout ' + selector] = (evt) ->
    if evt.type is 'keydown' and evt.which is 27

      # escape = cancel
      cancel.call this, evt
    else if evt.type is 'keyup' and evt.which is 13 or evt.type is 'focusout'

      # blur/return/enter = ok/submit if non-empty
      value = String(evt.target.value or '')
      if value
        ok.call this, value, evt
      else
        cancel.call this, evt

  events

activateInput = (input) ->
  input.focus()
  input.select()


######## Lists #######
Template.lists.loading = ->
  not listsHandle.ready()

Template.lists.lists = ->
  Lists.find {},
    sort:
      name: 1


Template.lists.events
  'mousedown .list': (evt) -> # select list
    Router.setList @_id

  'click .list': (evt) ->

    # prevent clicks on <a> from refreshing the page.
    evt.preventDefault()

  'dblclick .list': (evt, tmpl) -> # start editing list name
    Session.set 'editing_listname', @_id
    Deps.flush() # force DOM redraw, so we can focus the edit field
    activateInput tmpl.find('#list-name-input')


# Attach events to keydown, keyup, and blur on 'New list' input box.
Template.lists.events okCancelEvents('#new-list',
  ok: (text, evt) ->
    id = Lists.insert(name: text)
    Router.setList id
    evt.target.value = ''
)
Template.lists.events okCancelEvents('#list-name-input',
  ok: (value) ->
    Lists.update @_id,
      $set:
        name: value

    Session.set 'editing_listname', null

  cancel: ->
    Session.set 'editing_listname', null
)
Template.lists.selected = ->
  (if Session.equals('list_id', @_id) then 'selected' else '')

Template.lists.name_class = ->
  (if @name then '' else 'empty')

Template.lists.editing = ->
  Session.equals 'editing_listname', @_id


######### Todos ##########
Template.todos.loading = ->
  todosHandle and not todosHandle.ready()

Template.todos.any_list_selected = ->
  not Session.equals('list_id', null)

Template.todos.events okCancelEvents('#new-todo',
  ok: (text, evt) ->
    tag = Session.get('tag_filter')
    Todos.insert
      text: text
      list_id: Session.get('list_id')
      done: false
      timestamp: (new Date()).getTime()
      tags: (if tag then [tag] else [])

    evt.target.value = ''
)
Template.todos.todos = ->

  # Determine which todos to display in main pane,
  # selected based on list_id and tag_filter.
  list_id = Session.get('list_id')
  return {}  unless list_id
  sel = list_id: list_id
  tag_filter = Session.get('tag_filter')
  sel.tags = tag_filter  if tag_filter
  Todos.find sel,
    sort:
      timestamp: 1


Template.todo_item.tag_objs = ->
  todo_id = @_id
  _.map @tags or [], (tag) ->
    todo_id: todo_id
    tag: tag


Template.todo_item.done_class = ->
  (if @done then 'done' else '')

Template.todo_item.done_checkbox = ->
  (if @done then 'checked=\'checked\'' else '')

Template.todo_item.editing = ->
  Session.equals 'editing_itemname', @_id

Template.todo_item.adding_tag = ->
  Session.equals 'editing_addtag', @_id

Template.todo_item.events
  'click .check': ->
    Todos.update @_id,
      $set:
        done: not @done


  'click .destroy': ->
    Todos.remove @_id

  'click .addtag': (evt, tmpl) ->
    Session.set 'editing_addtag', @_id
    Deps.flush() # update DOM before focus
    activateInput tmpl.find('#edittag-input')

  'dblclick .display .todo-text': (evt, tmpl) ->
    Session.set 'editing_itemname', @_id
    Deps.flush() # update DOM before focus
    activateInput tmpl.find('#todo-input')

  'click .remove': (evt) ->
    tag = @tag
    id = @todo_id
    evt.target.parentNode.style.opacity = 0

    # wait for CSS animation to finish
    Meteor.setTimeout (->
      Todos.update
        _id: id
      ,
        $pull:
          tags: tag

    ), 300

Template.todo_item.events okCancelEvents('#todo-input',
  ok: (value) ->
    Todos.update @_id,
      $set:
        text: value

    Session.set 'editing_itemname', null

  cancel: ->
    Session.set 'editing_itemname', null
)
Template.todo_item.events okCancelEvents('#edittag-input',
  ok: (value) ->
    Todos.update @_id,
      $addToSet:
        tags: value

    Session.set 'editing_addtag', null

  cancel: ->
    Session.set 'editing_addtag', null
)

######### Tag Filter ##########

# Pick out the unique tags from all todos in current list.
Template.tag_filter.tags = ->
  tag_infos = []
  total_count = 0
  Todos.find(list_id: Session.get('list_id')).forEach (todo) ->
    _.each todo.tags, (tag) ->
      tag_info = _.find(tag_infos, (x) ->
        x.tag is tag
      )
      unless tag_info
        tag_infos.push
          tag: tag
          count: 1

      else
        tag_info.count++

    total_count++

  tag_infos = _.sortBy(tag_infos, (x) ->
    x.tag
  )
  tag_infos.unshift
    tag: null
    count: total_count

  tag_infos

Template.tag_filter.tag_text = ->
  @tag or 'All items'

Template.tag_filter.selected = ->
  (if Session.equals('tag_filter', @tag) then 'selected' else '')

Template.tag_filter.events 'mousedown .tag': ->
  if Session.equals('tag_filter', @tag)
    Session.set 'tag_filter', null
  else
    Session.set 'tag_filter', @tag


######### Tracking selected list in URL ##########
TodosRouter = Backbone.Router.extend(
  routes:
    ':list_id': 'main'

  main: (list_id) ->
    oldList = Session.get('list_id')
    if oldList isnt list_id
      Session.set 'list_id', list_id
      Session.set 'tag_filter', null

  setList: (list_id) ->
    @navigate list_id, true
)
Router = new TodosRouter
Meteor.startup ->
  Backbone.history.start pushState: true
