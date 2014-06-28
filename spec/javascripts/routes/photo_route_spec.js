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
      var applicationController;
      beforeEach(function() {
        applicationController = testHelper.lookup('controller', 'application');
      });

      describe('album', function() {
        it("is the photo's album", function() {
          var check = function() {
            if (applicationController.get('album')) {
              expect(applicationController.get('album').get('name')).toBe("Inbox");
              done();
            } else {
              setTimeout(check, 50);
            }
          }
          setTimeout(check, 50);
          subject();
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

      /*
       * FIXME: results in a JSON parser error
       * try after upgrading ember-data
      describe('parentHeader', function() {
        it("is the photo's album name", function() {
          subject();
          expect(applicationController.get('parentHeader')).toBe("Inbox"));
        });
      });
      */
    });
  });
});
