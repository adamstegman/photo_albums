PhotoAlbums.IndexRoute = Ember.Route.extend({
  redirect: function () {
    this.transitionTo('album', 'inbox');
  }
});
