# List of columns in the table # with respective css classes
_.extend Template['table-header'],
  columns: -> [
    class: 'col-name'
    title: 'Name'
  ,
    class: 'col-author'
    title: 'Author'
  ,
    class: 'col-language'
    title: 'Language'
  ,
    class: 'col-genre'
    title: 'Genre'
  ,
    class: 'col-year'
    title: 'Year'
  ,
    class: 'col-notes'
    title: 'Notes'
  ]
