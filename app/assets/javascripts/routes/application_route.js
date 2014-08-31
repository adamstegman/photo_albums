PhotoAlbums.ApplicationRoute = PhotoAlbums.Route.extend(Ember.SimpleAuth.ApplicationRouteMixin, {
  // TODO: find all albums other than Inbox in #63052042 in setupController
  // controller.set('albums', PhotoAlbums.Album.FIXTURES);

  actions: {
    startUploadActivityIndicator: function(id) {
      this._startUploadActivityIndicator(id);
    },
    stopUploadActivityIndicator: function(id) {
      this._stopUploadActivityIndicator(id);
    }
  },

  _startUploadActivityIndicator: function(id) {
    this.get('controller').startUploadActivityIndicator(id);
  },
  _stopUploadActivityIndicator: function(id) {
    this.get('controller').stopUploadActivityIndicator(id);
  }
});
