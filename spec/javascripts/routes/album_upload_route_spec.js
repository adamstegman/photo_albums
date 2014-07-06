describe('PhotoAlbums.AlbumUploadRoute', function() {
  beforeEach(function() {
    PhotoAlbums.reset();
  });

  var route;
  beforeEach(function() {
    route = testHelper.lookup('route', 'album.upload');
  });

  describe('#setupController', function() {
    var subject = function() {
      route.setupController(controller, undefined);
    };

    var controller;
    beforeEach(function() {
      controller = testHelper.lookup('controller', 'album.upload');
      controllerHelper.setModel(controller, 'album');
    });

    describe('sets route properties:', function() {
      describe('title', function() {
        it('is "Upload" with the album name', function() {
          subject();
          expect(route.get('title')).toBe("Upload - Inbox");
        });
      });
    });

    describe("sets ApplicationController properties:", function() {
      var applicationController;
      beforeEach(function() {
        applicationController = testHelper.lookup('controller', 'application');
      });

      describe('album', function() {
        it("is the controller", function() {
          subject();
          expect(applicationController.get('album')).toBe(controller);
        });
      });

      describe('header', function() {
        it("is falsy", function() {
          Ember.run(function() {
            applicationController.set('header', 'something');
          });

          subject();
          expect(applicationController.get('header')).toBeFalsy();
        });
      });

      describe('parentHeader', function() {
        it("is the album name", function() {
          subject();
          expect(applicationController.get('parentHeader')).toBe("Inbox");
        });
      });
    });
  });
});
