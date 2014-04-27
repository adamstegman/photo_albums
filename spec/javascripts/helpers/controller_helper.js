window.controllerHelper = (function() {
  return {
    setModel: function(controller, type) {
      var model = modelHelper.fake(type);
      controller.set('model', model);

      var attributes = modelHelper.attributesFor(type);
      for (var attribute in attributes) {
        if (attributes.hasOwnProperty(attribute)) {
          controller.set('model.' + attribute, model.get(attribute));
        }
      }

      return model;
    }
  };
})();
