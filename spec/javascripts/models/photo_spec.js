describe('PhotoAlbums.Photo', function() {
  beforeEach(function() {
    PhotoAlbums.reset();
  });

  var photo;
  beforeEach(function() {
    Ember.run(function() {
      photo = testHelper.lookup('store').createRecord('photo', {blobPath: 'test-bucket/key/path'});
    });
  });

  describe('base64Content', function() {
    var fakeS3;
    beforeEach(function() {
      fakeS3 = {
        getObject: jasmine.createSpy('S3.getObject').and.stub()
      };
      Ember.run(function() {
        var session = testHelper.lookup('store').createRecord('blobSession', {
          get: function(property) { if (property === 's3') return fakeS3; }
        });
        photo.set('blobSession', session);
      });
    });

    beforeEach(function() {
      Ember.run(function() {
        photo.set('blobBucket', 'test-bucket');
        photo.set('blobKey', 'key/path');
      });
    });

    it("fetches the content from S3", function() {
      // first call is undefined and kicks off the fetch
      expect(photo.get('base64Content')).toBeUndefined();

      var getObjectArgs = fakeS3.getObject.calls.argsFor(0);
      expect(getObjectArgs[0]).toEqual({Bucket: 'test-bucket', Key: 'key/path'});

      bodyBuffer = {
        toString: function(encoding) { if (encoding === 'base64') return "content"; }
      };
      getObjectArgs[1].call(undefined, null, {Body: bodyBuffer});

      // once the callback is called the value is returned
      expect(photo.get('base64Content')).toBe("content");
    });

    it("fails if S3 returns an error", function() {
      // first call is undefined and kicks off the fetch
      expect(photo.get('base64Content')).toBeUndefined();

      var getObjectArgs = fakeS3.getObject.calls.argsFor(0);
      getObjectArgs[1].call(undefined, "some error", null);

      expect(photo.get('base64Content')).toBeUndefined();
    });
  });
});
