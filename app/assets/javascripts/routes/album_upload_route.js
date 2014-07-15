PhotoAlbums.AlbumUploadRoute = PhotoAlbums.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {
  setupController: function(controller, model) {
    this._super(controller, model);
    this.setApplicationContext(controller);
    this.set('title', "Upload - " + controller.get('name'));
  },

  setApplicationContext: function(controller) {
    var applicationController = this.controllerFor('application');
    Ember.run(function() {
      applicationController.set('album', controller);
      applicationController.set('header', undefined);
      applicationController.set('parentHeader', controller.get('name'));
    });
  },

  actions: {
    upload: function(photoData, params) {
      this._upload(photoData, params);
    }
  },

  _upload: function(photoData, params) {
    var _this = this;
    Ember.run(function() {
      _this.getSession().then(function(session) {
        params.Bucket = session.get('id');
        params.Key = uuid.v4();
        params.Body = photoData;
        var s3 = session.get('s3');
        Ember.run(function() {
          s3.putObject(params, function(err, data) {
            if (err) {
              // FIXME: handle error cases
              console.error(err);
            } else {
              console.log("DEBUG: success");
            }
          });
        });
      });
    });
  },

  getSession: function() {
    var _this = this;
    return new Ember.RSVP.Promise(function(resolve, reject) {
      $.getJSON('/blob_session', function(data) {
        Ember.run(function() {
          _this.store.all('blobSession').forEach(function(session) {
            if (session.get('id') === data['blob_session']['id']) {
              session.deleteRecord();
              _this.store.dematerializeRecord(session);
            }
          });

          var blobSessionAttributes = _this.store.serializerFor('blobSession').normalize(PhotoAlbums.BlobSession, data['blob_session']);
          resolve(_this.store.push('blobSession', blobSessionAttributes));
        });
      });
    });
  }
});
