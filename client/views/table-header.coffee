# List of columns in the table # with respective css classes
_.extend Template['table-header'],
  columns: -> [
    class: 'col-name'
    title: 'Name'
  ,
    class: 'col-author-name'
    title: 'Author name'
  ,
    class: 'col-author-surname'
    title: 'Author surname'
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
