describe('PhotoAlbums.AlbumUploadController', function() {
  beforeEach(function() {
    PhotoAlbums.reset();
  });

  var controller;
  beforeEach(function() {
    controller = testHelper.lookup('controller', 'album.upload');
    controllerHelper.setModel(controller, 'album');
  });

  describe('upload action', function() {
    it("uploads the photo to S3 using a blob session from the server", function() {
      var params, callback;
      var putObject = jasmine.createSpy('putObject');
      putObject.and.callFake(function(p, c) {
        params = p;
        callback = c;
      });
      var blobSession = jasmine.createSpyObj('blobSession', ['get']);
      blobSession.get.and.callFake(function(param) {
        if (param === 'id') {
          return 'some-bucket';
        } else if (param === 's3') {
          return {putObject: putObject};
        }
      });
      var blobSessionPromise = new Ember.RSVP.Promise(function(resolve) {
        Ember.run(function() {
          resolve(blobSession);
        });
      });
      spyOn(controller, 'getSession').and.returnValue(blobSessionPromise);
      spyOn(uuid, 'v4').and.returnValue("some-key");

      controller.send('upload', "some-data", {ContentType: "some/type"});

      expect(params.Bucket).toBe("some-bucket");
      expect(params.Key).toBe("some-key");
      expect(params.Body).toBe("some-data");
      expect(params.ContentType).toBe("some/type");
      expect(typeof callback).toBe("function");
    });

    it("uploads the photo information to the server", function() {
      // FIXME
    });
  });

  describe('getSession', function() {
    beforeEach(function() {
      PhotoAlbums.ApplicationAdapter = DS.ActiveModelAdapter.extend();
    });
    afterEach(function() {
      PhotoAlbums.ApplicationAdapter = DS.FixtureAdapter.extend();
    });

    afterEach(function() {
      controller.store.all('blobSession').forEach(function(session) {
        session.deleteRecord();
        controller.store.dematerializeRecord(session);
      });
    });

    beforeEach(function() {
      jasmine.Ajax.install();
    });
    afterEach(function() {
      jasmine.Ajax.uninstall();
    });
    var stubSuccessfulBlobSessionRequest = function(id) {
      jasmine.Ajax.stubRequest('/blob_session').andReturn({
        status: 200,
        contentType: 'application/json',
        responseText: '{"blob_session":{"id":"' + id + '","access_key_id":"some-access-key"}}'
      });
    };

    it("returns a promise for session credentials", function(done) {
      stubSuccessfulBlobSessionRequest('session-bucket-promise');
      controller.getSession().then(function(blobSession) {
        expect(blobSession.get('id')).toBe('session-bucket-promise');
        expect(blobSession.get('accessKeyId')).toBe("some-access-key");
        done();
      });
    });

    describe("when a session for the same bucket already exists", function() {
      beforeEach(function() {
        Ember.run(function() {
          controller.store.push('blobSession', {id: "existing-bucket", accessKeyId: "should-be-gone"});
        });
      });

      it("creates a new session with the same id", function(done) {
        stubSuccessfulBlobSessionRequest('existing-bucket');

        controller.getSession().then(function(blobSession) {
          expect(blobSession.get('id')).toBe('existing-bucket');
          expect(blobSession.get('accessKeyId')).toBe("some-access-key");

          var size = 0;
          controller.store.all('blobSession').forEach(function(session) {
            size++;
            expect(session).toBe(blobSession);
            expect(size).toBe(1);
          });
          done();
        });
      });
    });
  });
});
