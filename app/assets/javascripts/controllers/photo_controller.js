PhotoAlbums.PhotoController = Ember.ObjectController.extend({
  dataURI: function() {
    var content = this.get('model.base64Content');
    if (content) {
      return "data:" + this.get('model.contentType') + ";base64," + content;
    } else {
      return "";
    }
  }.property('model.contentType', 'model.base64Content'),

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
