Lists = new Meteor.Collection('lists');
Todos = new Meteor.Collection('todos');
Books = new Meteor.Collection('books');
tb = Observatory.getToolbox()
Observatory.setSettings({
  logHttp: false
});
