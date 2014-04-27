PhotoAlbums.AlbumRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {
  setupController: function(controller, model) {
    this._super(controller, model);
    this.setApplicationContext(controller);
  },

  setApplicationContext: function(controller) {
    var applicationController = this.controllerFor('application');
    Ember.run(function() {
      applicationController.set('album', controller);
      applicationController.set('title', controller.get('name'));
      applicationController.set('parentTitle', undefined);
    });
  }
});
