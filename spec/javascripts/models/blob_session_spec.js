describe('PhotoAlbums.BlobSession', function() {
  beforeEach(function() {
    PhotoAlbums.reset();
  });

  var session;
  beforeEach(function() {
    Ember.run(function() {
      session = testHelper.lookup('store').createRecord(
        'blobSession',
        {
          sessionToken: 'token',
          accessKeyId: 'access-key',
          secretAccessKey: 'secret-access-key'
        }
      );
    });
  });

  describe('s3', function() {
    it("returns an S3 service with the session credentials", function() {
      var s3 = session.get('s3');
      expect(s3.config.credentials.accessKeyId).toBe('access-key');
      expect(s3.config.credentials.secretAccessKey).toBe('secret-access-key');
    });
  });
});
