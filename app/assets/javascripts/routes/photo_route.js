PhotoAlbums.PhotoRoute = PhotoAlbums.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {
  setupController: function(controller, model) {
    this._super(controller, model);
    this.set('title', this.formatTitle(controller));
    this.setApplicationContext();

    var _this = this;
    Ember.run(function() {
      controller.get('album').then(function(album) {
        _this.set('title', _this.formatTitle(controller, album));
        _this.setApplicationContext(album);
      });
    });
  },

  setApplicationContext: function(album) {
    var _this = this;
    Ember.run(function() {
      var applicationController = _this.controllerFor('application');
      applicationController.set('header', undefined);
      if (album) {
        applicationController.set('album', album);
        applicationController.set('parentHeader', album.get('name'));
      }
    });
  },

  formatTitle: function(controller, album) {
    var title = "" + controller.get('filename');
    if (album) {
      title += " - " + album.get('name');
    }
    return title;
  }
});
