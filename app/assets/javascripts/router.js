PhotoAlbums.Router.map(function() {
  this.route('login');
  this.resource('album', {path: '/:album_id'}, function() {
  });
  this.route('photo', {path: 'photos/:photo_id'});
});
