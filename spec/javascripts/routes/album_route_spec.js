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

  describe('#setupController', function() {
    var subject = function() {
      route.setupController(controller, undefined);
    };

    describe('sets route properties:', function() {
      describe('title', function() {
        it("is the album name", function() {
          subject();
          expect(route.get('title')).toBe("Inbox");
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
        it("is the album name", function() {
          subject();
          expect(applicationController.get('header')).toBe(controller.get('name'));
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
