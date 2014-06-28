PhotoAlbums.PhotoRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {
  setupController: function(controller, model) {
    this._super(controller, model);
    this.setApplicationContext(controller);
  },

  setApplicationContext: function(controller) {
    var applicationController = this.controllerFor('application');
    Ember.run(function() {
      applicationController.set('header', undefined);
      controller.get('album').then(function(album) {
        applicationController.set('album', album);
        applicationController.set('parentHeader', album.get('name'));
      });
    });
  }
});
