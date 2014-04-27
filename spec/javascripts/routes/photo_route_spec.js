describe('PhotoAlbums.PhotoRoute', function() {
  beforeEach(function() {
    PhotoAlbums.reset();
  });

  var route;
  beforeEach(function() {
    route = testHelper.lookup('route', 'photo');
  });

  var controller;
  beforeEach(function() {
    controller = testHelper.lookup('controller', 'photo');
    controllerHelper.setModel(controller, 'photo');
  });

  describe('#setApplicationContext', function() {
    var subject = function() {
      route.setApplicationContext(controller);
    };

    describe("sets ApplicationController properties:", function() {
      var album;
      beforeEach(function() {
        album = PhotoAlbums.Album.FIXTURES[0];
      });

      var applicationController;
      beforeEach(function() {
        applicationController = testHelper.lookup('controller', 'application');
      });

      describe('album', function() {
        it("is the photo's album", function() {
          subject();
          expect(applicationController.get('album').get('name')).toBe(album.name);
        });
      });

      describe('title', function() {
        it("is falsy", function() {
          Ember.run(function() {
            applicationController.set('title', 'something');
          });

          subject();
          expect(applicationController.get('title')).toBeFalsy();
        });
      });

      describe('parentTitle', function() {
        it("is the photo's album name", function() {
          subject();
          expect(applicationController.get('parentTitle')).toBe(album.name));
        });
      });
    });
  });
});
