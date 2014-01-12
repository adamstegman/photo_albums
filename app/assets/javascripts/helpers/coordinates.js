Ember.Handlebars.registerBoundHelper('coordinates', function(latitude, longitude) {
  if (latitude && longitude) {
    return latitude.toFixed(3) + ", " + longitude.toFixed(3);
  } else {
    return "";
  }
});
