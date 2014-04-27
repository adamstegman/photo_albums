describe('PhotoAlbums.AlbumRoute', function() {
  beforeEach(function() {
    PhotoAlbums.reset();
  });

  var route;
  beforeEach(function() {
    route = testHelper.lookup('route', 'album');
  });

  var controller;
  beforeEach(function() {
    controller = testHelper.lookup('controller', 'album');
    controllerHelper.setModel(controller, 'album');
  });

  describe('#setApplicationContext', function() {
    var subject = function() {
      route.setApplicationContext(controller);
    };

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

      describe('title', function() {
        it("is the album name", function() {
          subject();
          expect(applicationController.get('title')).toBe(controller.get('name'));
        });
      });

      describe('parentTitle', function() {
        it("is falsy", function() {
          Ember.run(function() {
            applicationController.set('parentTitle', 'something');
          });

          subject();
          expect(applicationController.get('parentTitle')).toBeFalsy();
        });
      });
    });
  });
});
