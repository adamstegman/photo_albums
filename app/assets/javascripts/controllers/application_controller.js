PhotoAlbums.ApplicationController = Ember.Controller.extend({
  isUploading: Ember.computed.notEmpty('uploadActivityIndicators.[]'),
  startUpload: function(id) {
    var uploads = this.get('uploadActivityIndicators');
    if (uploads) {
      uploads.pushObject(id);
    } else {
      var _this = this;
      Ember.run(function() {
        _this.set('uploadActivityIndicators', Ember.A([id]));
      });
    }
  },
  stopUpload: function(id) {
    var uploads = this.get('uploadActivityIndicators');
    if (uploads) {
      uploads.removeObject(id);
    }
  }
});
