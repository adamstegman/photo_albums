window.controllerHelper = (function() {
  return {
    setModel: function(controller, type) {
      var model = modelHelper.fake(type);
      controller.set('model', model);

      var attributes = modelHelper.attributesFor(type);
      for (var attribute in attributes) {
        if (attributes.hasOwnProperty(attribute)) {
          // FIXME: simulate actual relationships between models
          // remove, or at least abstract, after upgrading ember-data
          if (attribute == 'album') {
            var album = modelHelper.fake('album');
            var albumPromise = new Ember.RSVP.Promise(function(resolve) { resolve(album); });
            controller.set('model.album', albumPromise);
            var albumAttributes = modelHelper.attributesFor('album');
            for (var albumAttribute in albumAttributes) {
              if (albumAttributes.hasOwnProperty(albumAttribute)) {
                var attributePromise = new Ember.RSVP.Promise(function(resolve) { resolve(album.get(albumAttribute)); });
                controller.set('model.album.' + albumAttribute, attributePromise);
              }
            }
          } else {
            controller.set('model.' + attribute, model.get(attribute));
          }
        }
      }

      return model;
    }
  };
})();
