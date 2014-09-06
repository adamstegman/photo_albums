PhotoAlbums.UploadController = Ember.ArrayController.extend({
  hasUploads: Ember.computed.notEmpty('uploads.[]')
});
