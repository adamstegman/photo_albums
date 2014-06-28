PhotoAlbums.AlbumRoute = PhotoAlbums.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {
  setupController: function(controller, model) {
    this._super(controller, model);
    this.setApplicationContext(controller);
    this.set('title', controller.get('name'));
  },

  setApplicationContext: function(controller) {
    var applicationController = this.controllerFor('application');
    Ember.run(function() {
      applicationController.set('album', controller);
      applicationController.set('header', controller.get('name'));
      applicationController.set('parentHeader', undefined);
    });
  }
});
