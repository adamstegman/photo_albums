PhotoAlbums.Album = DS.Model.extend({
  name: DS.attr('string'),
  description: DS.attr('string')
});

PhotoAlbums.Album.FIXTURES = [
  {
    id: 1,
    name: 'Inbox',
    description: 'Unsorted photos'
  }
];
