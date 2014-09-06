PhotoAlbums.UploadActivityIndicatorComponent = Ember.Component.extend({
  classNames: 'upload-activity-indicator',

  didInsertElement: function() {
    var spinner = new Spinner(this.get('spinnerOptions'));
    this.set('spinner', spinner);
    spinner.spin(this.get('element'));
  },
  willDestroyElement: function() {
    this.get('spinner').stop();
    this.set('spinner', undefined);
  },

  spinnerOptions: function() {
    return this.get('styles')[this.get('style')];
  }.property('style'),

  styles: {
    nav: {
      color: '#fff',
      radius: 6,
      length: 5,
      width: 2.5
    },
    page: {
      color: '#000',
      radius: 3,
      length: 3,
      width: 2
    }
  }
});
