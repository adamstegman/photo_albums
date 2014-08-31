PhotoAlbums.UploadActivityIndicatorComponent = Ember.Component.extend({
  classNames: 'upload-activity-indicator',

  didInsertElement: function() {
    var spinner = new Spinner({
      color: '#fff',
      radius: 6,
      length: 5,
      width: 2.5
    });
    this.set('spinner', spinner);
    spinner.spin(this.get('element'));
  },
  willDestroyElement: function() {
    this.get('spinner').stop();
    this.set('spinner', undefined);
  }
});
