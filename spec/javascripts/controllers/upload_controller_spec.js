describe("PhotoAlbums.UploadController", function() {
  beforeEach(function() {
    PhotoAlbums.reset();
  });

  var controller;
  beforeEach(function() {
    controller = testHelper.lookup('controller', 'upload');
  });
  
  describe("#hasUploads", function() {
    it("is true if uploads is not empty", function() {
      controller.set('uploads', Ember.A(['a']));
      expect(controller.get('hasUploads')).toBeTruthy();
    });

    it("is false if uploads is empty", function() {
      controller.set('uploads', Ember.A([]));
      expect(controller.get('hasUploads')).toBeFalsy();
    });
  });
});
