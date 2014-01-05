PhotoAlbums.ApplicationController = Ember.Controller.extend({
  needs: ['album', 'photo'],
  isAlbum: function() {
    return this.get("currentPath") == "album";
  }.property("currentPath"),
  album: function() {
    if (this.get("isAlbum")) {
      return this.get("controllers.album");
    } else {
      return this.get("controllers.photo.album");
    }
  }.property("currentPath")
});
