//= require aws-sdk/dist/aws-sdk

PhotoAlbums.BlobSession = DS.Model.extend({
  sessionToken: DS.attr('string'),
  accessKeyId: DS.attr('string'),
  secretAccessKey: DS.attr('string'),

  s3: function() {
    // use us-east-1 region so that the hostname is s3.amazonaws.com
    return new AWS.S3({accessKeyId: this.get('accessKeyId'), secretAccessKey: this.get('secretAccessKey'), sessionToken: this.get('sessionToken'), region: 'us-east-1'});
  }.property('accessKeyId', 'secretAccessKey', 'sessionToken')
});
