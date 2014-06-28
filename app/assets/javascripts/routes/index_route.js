PhotoAlbums.IndexRoute = PhotoAlbums.Route.extend({
  redirect: function () {
    this.transitionTo('album.index', 'inbox');
  }
});
