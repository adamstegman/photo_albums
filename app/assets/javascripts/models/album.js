PhotoAlbums.Album = DS.Model.extend({
  name: DS.attr('string'),

  photos: DS.hasMany('photo', {async: true})
});
