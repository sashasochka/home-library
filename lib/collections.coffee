# global collection objects
@AllowedUsers = new Meteor.Collection 'allowed_users'
@Books = new Meteor.Collection 'books'
@BooksCount = new Meteor.Collection 'books-count'
@GenreOptions = new Meteor.Collection 'genre-options'
@LangOptions = new Meteor.Collection 'lang-options'
