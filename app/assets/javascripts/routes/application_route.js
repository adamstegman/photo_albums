PhotoAlbums.ApplicationRoute = Ember.Route.extend(Ember.SimpleAuth.ApplicationRouteMixin, {
  setupController: function(controller, model) {
    // TODO: find all albums other than Inbox in #63052042
    // controller.set('albums', PhotoAlbums.Album.FIXTURES);
  }
});
