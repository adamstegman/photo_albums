Ember.Handlebars.registerBoundHelper('formatTakenAt', function(takenAt) {
  return moment(takenAt).format('LLL');
});
