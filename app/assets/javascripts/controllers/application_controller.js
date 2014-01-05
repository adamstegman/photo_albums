PhotoAlbums.ApplicationController = Ember.Controller.extend({
  needs: ['album'],
  album: Ember.computed.alias("controllers.album")
});
