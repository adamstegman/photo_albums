PhotoAlbums.IndexRoute = Ember.Route.extend({
  beforeModel: function () {
    this.transitionTo('/inbox');
  }
});