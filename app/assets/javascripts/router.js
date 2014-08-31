PhotoAlbums.Router.map(function() {
  this.route('login');
  this.route('album', {path: 'albums/:album_id'});
  this.route('photo', {path: 'photos/:photo_id'});
  this.route('upload');
});
