PhotoAlbums.UploadRoute = PhotoAlbums.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {
  setupController: function(controller) {
    var uploads = this.controllerFor('application').get('uploads');
    if (!uploads) {
      uploads = Ember.A([]);
    }
    controller.set('model', uploads);

    this.setApplicationContext();
    this.set('title', "Upload");
  },

  setApplicationContext: function() {
    var applicationController = this.controllerFor('application');
    Ember.run(function() {
      applicationController.set('album', undefined);
      applicationController.set('header', "Upload");
      applicationController.set('parentHeader', undefined);
    });
  },

  actions: {
    upload: function(photoData, photoAttributes) {
      this._upload(photoData, photoAttributes);
    },
    startUpload: function(id, photoAttributes) {
      this._startUpload(id, photoAttributes);
      return true;
    },
    stopUpload: function(id, photoAttributes) {
      this._stopUpload(id, photoAttributes);
      return true;
    }
  },

  _startUpload: function(id, photoAttributes) {
    var controller = this.get('controller');
    var uploads = controller.get('uploads');
    if (!uploads) {
      uploads = Ember.A([]);
      Ember.run(function() {
        controller.set('uploads', uploads);
      });
    }
    uploads.pushObject(photoAttributes);
  },

  _stopUpload: function(id, photoAttributes) {
    var controller = this.get('controller');
    var uploads = controller.get('uploads');
    if (uploads) {
      uploads.removeObject(photoAttributes);
    }
  },

  _upload: function(photoData, photoAttributes) {
    var _this = this;
    Ember.run(function() {
      _this.getSession().then(_this.uploadAndCreatePhoto(photoData, photoAttributes));
    });
  },

  uploadAndCreatePhoto: function(photoData, photoAttributes) {
    var _this = this;
    return function(session) {
      photoAttributes.blobBucket = session.get('id');
      photoAttributes.blobKey    = uuid.v4();
      var s3Params = {
        Bucket: photoAttributes.blobBucket,
        Key: photoAttributes.blobKey,
        Body: photoData,
        ContentType: photoAttributes.contentType
      };
      var s3 = session.get('s3');
      Ember.run(function() {
        _this.send('startUpload', photoAttributes.blobKey, photoAttributes);
        s3.putObject(s3Params, _this.createPhotoFromAttributes(photoAttributes));
      });
    };
  },

  createPhotoFromAttributes: function(photoAttributes) {
    var _this = this;
    return function(err, data) {
      if (err) {
        _this.send('stopUpload', photoAttributes.blobKey, photoAttributes);
        _this.send('uploadError', photoAttributes, err);
      } else {
        Ember.run(function() {
          var photo = _this.store.createRecord('photo', photoAttributes);
          photo.save();
          _this.send('stopUpload', photoAttributes.blobKey, photoAttributes);
        });
      }
    };
  },

  getSession: function() {
    var _this = this;
    return new Ember.RSVP.Promise(function(resolve, reject) {
      $.getJSON('/blob_session', _this.createBlobSession(resolve, reject));
    });
  },

  createBlobSession: function(resolve, reject) {
    var _this = this;
    return function(data) {
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
    };
  }
});
