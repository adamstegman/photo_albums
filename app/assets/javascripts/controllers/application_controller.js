PhotoAlbums.ApplicationController = Ember.Controller.extend({
  isUploading: Ember.computed.notEmpty('uploadActivityIndicators.[]'),
  startUploadActivityIndicator: function(id) {
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
  stopUploadActivityIndicator: function(id) {
    var uploads = this.get('uploadActivityIndicators');
    if (uploads) {
      uploads.removeObject(id);
    }
  }
});
