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
});
