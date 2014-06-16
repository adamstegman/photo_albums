PhotoAlbums.Photo = DS.Model.extend({
  filename: DS.attr('string'),
  contentType: DS.attr('string'),
  width: DS.attr('number'),
  height: DS.attr('number'),
  latitude: DS.attr('number'),
  longitude: DS.attr('number'),
  takenAt: DS.attr('date'),
  comment: DS.attr('string'),
  blobBucket: DS.attr('string'),
  blobKey: DS.attr('string'),
  
  album: DS.belongsTo('album'),
  blobSession: DS.belongsTo('blobSession'),

  base64Content: function() {
    var photo = this;
    this.get('blobSession').get('s3').getObject(
      {Bucket: this.get('blobBucket'), Key: this.get('blobKey')},
      function(err, data) {
        if (!err) {
          photo.set('base64Content', data.Body.toString('base64'));
        }
      }
    );
    return undefined;
  }.property('blobBucket', 'blobKey')
});
