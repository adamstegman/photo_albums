PhotoAlbums.Router.map(function() {
  this.resource('login');
  this.resource('album', {path: '/:album_id'});
  this.resource('photo', {path: 'photos/:photo_id'});
});
