PhotoAlbums.LoginRoute = Ember.Route.extend({
  setupController: function(controller, model) {
    this._super(controller, model);
    this.setApplicationContext(controller);
  },

  setApplicationContext: function(controller) {
    var applicationController = this.controllerFor('application');
    Ember.run(function() {
      applicationController.set('album', undefined);
      applicationController.set('header', 'Login');
      applicationController.set('parentHeader', undefined);
    });
  }
});
