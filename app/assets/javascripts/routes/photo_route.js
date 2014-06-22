PhotoAlbums.PhotoRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {
  setupController: function(controller, model) {
    this._super(controller, model);
    this.setApplicationContext(controller);
  },

  setApplicationContext: function(controller) {
    var applicationController = this.controllerFor('application');
    Ember.run(function() {
      applicationController.set('title', undefined);
      controller.get('album').then(function(album) {
        applicationController.set('album', album);
        applicationController.set('parentTitle', album.get('name'));
      });
    });
  }
});
