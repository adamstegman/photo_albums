PhotoAlbums.Router.map(function() {
  this.route('login');
  this.resource('album', {path: 'albums/:album_id'}, function() {
    this.route('upload');
  });
  this.route('photo', {path: 'photos/:photo_id'});
});
