describe('PhotoAlbums.ApplicationRoute', function() {
  beforeEach(function() {
    PhotoAlbums.reset();
  });

  var route;
  beforeEach(function() {
    route = testHelper.lookup('route', 'application');
  });

  var controller;
  beforeEach(function() {
    controller = testHelper.lookup('controller', 'application');
    route.setupController(controller);
  });

  describe("uploadError action", function() {
    it("sets the uploadError property on the controller", function() {
      err = new Error("some-error");
      Ember.run(function() {
        route._uploadError({filename: "some-file"}, err);
      });
      expect(controller.get('uploadError')).toEqual({filename: "some-file", err: err});
    });

    it("sets the uploadError property on the controller when no attributes are given", function() {
      err = new Error("some-error");
      Ember.run(function() {
        route._uploadError(undefined, err);
      });
      expect(controller.get('uploadError')).toEqual({err: err});
    });
  });
});
