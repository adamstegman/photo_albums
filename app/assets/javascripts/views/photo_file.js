PhotoAlbums.PhotoFile = Ember.View.extend({
  tagName: 'input',
  attributeBindings: ['type'],
  type: 'file',

  change: function(e) {
    if (e.target.files.length > 0) {
      var view = this;
      var file = e.target.files[0];
      var metadata = {contentType: file.type, filename: this.basename(file.name)};

      var reader = new FileReader();
      reader.onload = function(e) {
        view.get('controller').send('upload', e.target.result, metadata);
      };
      reader.readAsArrayBuffer(file);
    }
  },

  basename: function(path) {
    // strip leading segments that are followed by forward- or back-slashes.
    return path.replace(/[^\\]+\\|\/?[^\/]+\//g, '');
  }
});
