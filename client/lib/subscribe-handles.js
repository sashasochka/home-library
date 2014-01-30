// Create client-side subscriptions for server-published
// collections in a global object
Handles = {
  booksCount: Meteor.subscribe('books-count'),
  books: null
};
