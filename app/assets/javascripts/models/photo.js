PhotoAlbums.Photo = DS.Model.extend({
  filename: DS.attr('string'),
  contentType: DS.attr('string'),
  width: DS.attr('number'),
  height: DS.attr('number'),
  content: DS.attr('string'),
  
  album: DS.belongsTo('album'),

  dataURI: function() {
    return "data:" + this.get("contentType") + ";base64," + this.get("content");
  }.property('contentType', 'content')
});
