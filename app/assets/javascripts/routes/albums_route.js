PhotoAlbums.AlbumsRoute = Ember.Route.extend({
  model: function() {
    return this.store.find('album');
  }
});

PhotoAlbums.AlbumsInboxRoute = Ember.Route.extend({
  model: function() {
    return this.store.filter('album', function (album) {
      return album.get('name') == 'Inbox';
    });
  },

  renderTemplate: function () {
    this.render('albums/show');
  }
});
