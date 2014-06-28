describe('PhotoAlbums.Route', function() {
  beforeEach(function() {
    PhotoAlbums.reset();
  });

  var route;
  beforeEach(function() {
    route = testHelper.lookup('route', 'application');
  });

  describe('afterModel', function() {
    it("sets the window title to the route title with a common suffix", function() {
      route.set('title', "some title");
      
      route.afterModel();

      expect(document.title).toBe("some title - Photo Albums");
    });

    it('sets the window title to "Photo Albums" by default', function() {
      route.afterModel();
      expect(document.title).toBe("Photo Albums");
    });
  });
});
