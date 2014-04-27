describe('PhotoAlbums.LoginRoute', function() {
  beforeEach(function() {
    PhotoAlbums.reset();
  });

  var route;
  beforeEach(function() {
    route = testHelper.lookup('route', 'login');
  });

  var controller;
  beforeEach(function() {
    controller = testHelper.lookup('controller', 'login');
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
        it("is falsy", function() {
          Ember.run(function() {
            applicationController.set('album', 'something');
          });

          subject();
          expect(applicationController.get('album')).toBeFalsy();
        });
      });

      describe('title', function() {
        it("is Login", function() {
          subject();
          expect(applicationController.get('title')).toBe("Login");
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
