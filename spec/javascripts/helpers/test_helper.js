window.testHelper = {
  lookup: function(object, object_name) {
    name = object_name || "main";
    return PhotoAlbums.__container__.lookup(object + ":" + name);
  }
}
