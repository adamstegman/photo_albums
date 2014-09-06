describe('PhotoAlbums.UploadRoute', function() {
  beforeEach(function() {
    PhotoAlbums.reset();
  });

  beforeEach(function() {
    jasmine.Ajax.install();
  });
  afterEach(function() {
    jasmine.Ajax.uninstall();
  });

  var route;
  beforeEach(function() {
    route = testHelper.lookup('route', 'upload');
  });

  var controller;
  beforeEach(function() {
    controller = testHelper.lookup('controller', 'upload');
    route.setupController(controller, undefined);
  });

  describe('getSession', function() {
    afterEach(function() {
      route.store.all('blobSession').forEach(function(session) {
        session.deleteRecord();
        route.store.dematerializeRecord(session);
      });
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
      route.getSession().then(function(blobSession) {
        expect(blobSession.get('id')).toBe('session-bucket-promise');
        expect(blobSession.get('accessKeyId')).toBe("some-access-key");
        done();
      });
    });

    describe("when a session for the same bucket already exists", function() {
      beforeEach(function() {
        Ember.run(function() {
          route.store.push('blobSession', {id: "existing-bucket", accessKeyId: "should-be-gone"});
        });
      });

      it("creates a new session with the same id", function(done) {
        stubSuccessfulBlobSessionRequest('existing-bucket');

        route.getSession().then(function(blobSession) {
          expect(blobSession.get('id')).toBe('existing-bucket');
          expect(blobSession.get('accessKeyId')).toBe("some-access-key");

          var size = 0;
          route.store.all('blobSession').forEach(function(session) {
            size++;
            expect(session).toBe(blobSession);
            expect(size).toBe(1);
          });
          done();
        });
      });
    });
  });

  describe('upload action', function() {
    var subject = function() {
      route._upload("some-data", {contentType: "some/type", filename: "some-file"});
    };

    var params, callback;
    var putObject;
    beforeEach(function() {
      putObject = jasmine.createSpy('putObject');
      putObject.and.callFake(function(p, c) {
        params = p;
        callback = c;
      });
    });

    beforeEach(function() {
      var blobSessionPromise = new Ember.RSVP.Promise(function(resolve) {
        var blobSession = jasmine.createSpyObj('blobSession', ['get']);
        blobSession.get.and.callFake(function(param) {
          if (param === 'id') {
            return 'some-bucket';
          } else if (param === 's3') {
            return {putObject: putObject};
          }
        });
        Ember.run(function() {
          resolve(blobSession);
        });
      });
      spyOn(route, 'getSession').and.returnValue(blobSessionPromise);
    });

    beforeEach(function() {
      spyOn(uuid, 'v4').and.returnValue("some-key");
    });

    it("uploads the photo to S3 using a blob session from the server", function() {
      subject();
      expect(params.Bucket).toBe("some-bucket");
      expect(params.Key).toBe("some-key");
      expect(params.Body).toBe("some-data");
      expect(params.ContentType).toBe("some/type");
      expect(typeof callback).toBe("function");
    });

    it("uploads the photo information to the server", function() {
      subject();
      callback(null);

      var photoInfoUpload = jasmine.Ajax.requests.mostRecent();
      expect(photoInfoUpload.method).toBe('POST');
      expect(photoInfoUpload.url).toBe('/photos');
      expect(JSON.parse(photoInfoUpload.params)).toEqual({
        photo: {
          blob_bucket: "some-bucket",
          blob_key: "some-key",
          content_type: "some/type",
          filename: "some-file",
          album_id: null,
          blob_session_id: null,
          comment: null,
          latitude: null,
          longitude: null,
          width: null,
          height: null,
          taken_at: null
        }
      });
    });

    xit("retries the photo information upload if something goes wrong", function() {
    });
  });

  describe('#setupController', function() {
    var subject = function() {
      route.setupController(controller, undefined);
    };

    describe('sets route properties:', function() {
      describe('title', function() {
        it('is "Upload"', function() {
          subject();
          expect(route.get('title')).toBe("Upload");
        });
      });
    });

    describe("sets controller properties:", function() {
      describe('model', function() {
        it("is the ongoing uploads when there are ongoing uploads", function() {
          testHelper.lookup('controller', 'application').set('uploads', [{filename: "some-file"}]);

          subject();
          expect(controller.get('model')).toEqual([{filename: "some-file"}]);
        });

        it("is an empty array when there have not been any uploads", function() {
          testHelper.lookup('controller', 'application').set('uploads', undefined);

          subject();
          expect(controller.get('model')).toEqual([]);
        });
      });
    });

    describe("sets ApplicationController properties:", function() {
      var applicationController;
      beforeEach(function() {
        applicationController = testHelper.lookup('controller', 'application');
      });

      describe('album', function() {
        it("is falsy", function() {
          Ember.run(function() {
            applicationController.set('album', 'something');
          });

          subject();
          expect(applicationController.get('album')).toBeFalsy();
        });
      });

      describe('header', function() {
        it("is upload", function() {
          subject();
          expect(applicationController.get('header')).toBe("Upload");
        });
      });

      describe('parentHeader', function() {
        it("is falsy", function() {
          Ember.run(function() {
            applicationController.set('parentHeader', 'something');
          });

          subject();
          expect(applicationController.get('parentHeader')).toBeFalsy();
        });
      });
    });
  });
});
