PhotoAlbums.Router.map(function() {
  this.resource('album', {path: '/:album_id'});
  this.resource('photo', {path: 'photos/:photo_id'});
});
