PhotoAlbums.Route = Ember.Route.extend({
  afterModel: function() {
    this.setTitle();
  },

  setTitle: function() {
    var title = this.get('title');
    if (title) {
      document.title = "" + title + " - Photo Albums";
    } else {
      document.title = "Photo Albums";
    }
  }.observes('title')
});
