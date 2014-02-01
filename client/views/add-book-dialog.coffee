template = Template['add-book-dialog']
_.extend template,
  show: ->
    bootbox.dialog
      message: template() # Render this template
      title: "New book"
      onEscape: _.noop # allow closing using escape keypress
      buttons:
        success:
          label: "Add book"
          className: "btn-success"
          callback: () ->
            valid = $('#add-book-form').parsley 'validate'
            if valid
              book =
                name: $('#input-book-name').val()
                author_name: $('#input-book-author-name').val()
                author_surname: $('#input-book-author-surname').val()
                lang: $('#input-book-lang').val()
                genre: $('#input-book-genre').val()
                year: _.parseInt $('#input-book-year').val()
                note: $('#input-book-note').val()
              Meteor.call 'insert-book', book
            valid
        danger:
          label: "Cancel",
          className: "btn-danger"
  'lang-option': -> LangOptions.find()
  'genre-option': -> GenreOptions.find()
  'default-genre': -> GenreOptions.findOne().option
  'default-year': ->
    template['max-year']()
  'max-year': -> new Date().getFullYear()
  'book-input-helper': (args...) ->
    hash_attrs = _.last(args).hash
    attrs_str = _.map(_.pairs(hash_attrs), (arr) -> "#{arr[0]}='#{arr[1]}'").join ' '
    attrs_str += _.chain(args).rest().filter(_.isString).join(' ').value()
    label = _.first args
    label += '*' if _.contains args, 'required'
    "<div><label for='#{hash_attrs.id}'>#{label}</label><input #{attrs_str}></div>"

