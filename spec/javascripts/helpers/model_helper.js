window.modelHelper = (function() {
  function toTypeClass(type) {
    return type.substring(0, 1).toUpperCase() + type.substring(1);
  };

  return {
    fake: function(type) {
      var model = jasmine.createSpyObj(type, ['get']);
      var attributes = this.attributesFor(type);
      model.get.and.callFake(function(property) {
        return attributes[property];
      });
      return model;
    },
    attributesFor: function(type) {
      return PhotoAlbums[toTypeClass(type)].FIXTURES[0];
    }
  };
})();
