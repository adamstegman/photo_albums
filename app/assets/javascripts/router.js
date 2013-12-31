PhotoAlbums.Router.map(function() {
  this.resource('albums', {path: '/albums'}, function() {
    this.route('inbox');
  });
});
