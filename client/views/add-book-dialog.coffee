template = Template['add-book-dialog']
_.extend template,
  'show': (data) ->
    is_editing = !!Session.get('editing-book-id')
    bootbox.dialog
      message: template data # Render this template
      title: if is_editing then "Change book information" else "New book"
      onEscape: _.noop # allow closing using escape keypress
      buttons:
        success:
          label: if is_editing then "Edit book" else "Add book"
          className: "btn-success"
          callback: ->
            valid = $('#add-book-form').parsley 'validate'
            if valid
              book =
                name: $('#input-book-name').val()
                author_name: $('#input-book-author-name').val()
                author_surname: $('#input-book-author-surname').val()
                lang: $('#input-book-lang').val()
                genre: $('#input-book-genre').val()
                year: _.parseInt $('#input-book-year').val() or 0
                note: $('#input-book-note').val()
              if is_editing
                Meteor.call 'edit-book', book, Session.get('editing-book-id'), (error) ->
                  bootbox.alert 'Error: cannot edit book. Check entered data' if error
              else
                Meteor.call 'insert-book', book, (error) ->
                  bootbox.alert 'Error: cannot insert book. Check entered data' if error
            valid
        danger:
          label: "Cancel",
          className: "btn-danger"
  'lang-option': -> LangOptions.find()
  'genre-option': -> GenreOptions.find()
  'max-year': -> new Date().getFullYear()
  'book-input-helper': (args...) ->
    hash_attrs = _.last(args).hash
    attrs_str = _.chain(hash_attrs)
      .pairs()
      .filter(_.last)
      .map((arr) -> "#{arr[0]}='#{arr[1]}'")
      .join(' ')
      .value()

    attrs_str += _.chain(args).rest().filter(_.isString).join(' ').value()
    label = _.first args
    label += '*' if _.contains args, 'required'
    "<div><label for='#{hash_attrs.id}'>#{label}</label><input #{attrs_str}></div>"

