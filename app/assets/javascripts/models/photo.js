PhotoAlbums.Photo = DS.Model.extend({
  filename: DS.attr('string'),
  contentType: DS.attr('string'),
  width: DS.attr('number'),
  height: DS.attr('number'),
  latitude: DS.attr('number'),
  longitude: DS.attr('number'),
  takenAt: DS.attr('date'),
  comment: DS.attr('string'),
  content: DS.attr('string'),
  
  album: DS.belongsTo('album'),

  dataURI: function() {
    return "data:" + this.get("contentType") + ";base64," + this.get("content");
  }.property('contentType', 'content'),

  locationURL: function() {
    var url = "https://maps.google.com/maps?q="
    if (this.get('comment')) {
      url += encodeURIComponent(this.get('comment'))
    } else {
      url += encodeURIComponent(this.get('filename'))
    }
    return url + "+(" + encodeURIComponent(this.get('filename')) + ")" +
      "+" + encodeURIComponent("@" + this.get('latitude') + "," + this.get('longitude'));
  }.property('latitude', 'longitude', 'filename', 'comment')
});
