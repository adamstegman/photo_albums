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
            controller.set('model.album', album);
            var albumAttributes = modelHelper.attributesFor('album');
            for (var albumAttribute in albumAttributes) {
              if (albumAttributes.hasOwnProperty(albumAttribute)) {
                controller.set('model.album.' + albumAttribute, album.get(albumAttribute));
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
