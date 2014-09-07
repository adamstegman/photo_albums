PhotoAlbums.ApplicationRoute = PhotoAlbums.Route.extend(Ember.SimpleAuth.ApplicationRouteMixin, {
  // TODO: find all albums other than Inbox in #63052042 in setupController
  // controller.set('albums', PhotoAlbums.Album.FIXTURES);

  actions: {
    startUpload: function(id) {
      this._startUpload(id);
    },
    stopUpload: function(id) {
      this._stopUpload(id);
    },

    uploadError: function(err) {
      this._uploadError(err);
    }
  },

  _startUpload: function(id) {
    this.get('controller').startUpload(id);
  },
  _stopUpload: function(id) {
    this.get('controller').stopUpload(id);
  },

  _uploadError: function(photoAttributes, err) {
    if (!photoAttributes) {
      photoAttributes = {};
    }
    photoAttributes.err = err;
    this.get('controller').set('uploadError', photoAttributes);
  }
});
