PhotoAlbums.PhotoController = Ember.ObjectController.extend({
  dataURI: function() {
    return "data:" + this.get('model.contentType') + ";base64," + this.get('model.content');
  }.property('model.contentType', 'model.content'),

  locationURL: function() {
    var url = "https://maps.google.com/maps?q="
    if (this.get('model.comment')) {
      url += encodeURIComponent(this.get('model.comment'))
    } else {
      url += encodeURIComponent(this.get('model.filename'))
    }
    return url + "+(" + encodeURIComponent(this.get('model.filename')) + ")" +
      "+" + encodeURIComponent("@" + this.get('model.latitude') + "," + this.get('model.longitude'));
  }.property('model.latitude', 'model.longitude', 'model.filename', 'model.comment'),

  photoId: function() {
    return "photo-" + this.get('model.id');
  }.property('model.id')
});
