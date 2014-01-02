PhotoAlbums.InboxRoute = Ember.Route.extend({
  model: function() {
    return this.store.find('album', 'inbox');
  },

  renderTemplate: function () {
    this.render('albums/show');
  }
});
