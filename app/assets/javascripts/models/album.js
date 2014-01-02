PhotoAlbums.Album = DS.Model.extend({
  name: DS.attr('string')
});

PhotoAlbums.Album.FIXTURES = [
  {
    id: 1,
    name: 'Inbox'
  }
];
