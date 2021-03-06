describe('PhotoAlbums.LoginRoute', function() {
  beforeEach(function() {
    PhotoAlbums.reset();
  });

  var route;
  beforeEach(function() {
    route = testHelper.lookup('route', 'login');
  });

  describe('#setupController', function() {
    var subject = function() {
      route.setupController(controller, undefined);
    };

    var controller;
    beforeEach(function() {
      controller = testHelper.lookup('controller', 'login');
    });

    describe('title', function() {
      it('is "Login"', function() {
        subject();
        expect(route.get('title')).toBe("Login");
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
        it("is Login", function() {
          subject();
          expect(applicationController.get('header')).toBe("Login");
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
