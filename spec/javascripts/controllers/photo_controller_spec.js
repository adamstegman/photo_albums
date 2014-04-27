describe('PhotoAlbums.PhotoController', function() {
  var controller, model;
  
  beforeEach(function() {
    PhotoAlbums.reset();

    controller = testHelper.lookup('controller', 'photo');
    model = controllerHelper.setModel(controller, 'photo');
  });

  describe('#dataURI', function() {
    it("returns a base64 data URI", function() {
      expect(controller.get('dataURI')).toMatch(/data:image\/jpeg;base64,[\/+=0-9A-z]+/);
    });
  });

  describe('#locationURL', function() {
    describe("when the photo does not have a comment", function() {
      it("returns a link to a map at the photo location labeled with the filename", function() {
        expect(controller.get('locationURL')).toBe(
          "https://maps.google.com/maps?q=" + model.get('filename') + "+(" + model.get('filename') + ")+%40" +
            model.get('latitude') + "%2C" + model.get('longitude')
        );
      });
    });

    describe("when the photo has a comment", function() {
      beforeEach(function() {
        controller.set('model.comment', "Special photo");
      });

      it("returns a link to a map at the photo location labeled with the comment", function() {
        expect(controller.get('locationURL')).toBe(
          "https://maps.google.com/maps?q=Special%20photo" + "+(" + model.get('filename') + ")+%40" +
            model.get('latitude') + "%2C" + model.get('longitude')
        );
      });
    });
  });

  describe('#photoId', function() {
    it("returns a unique photo id", function() {
      expect(controller.get('photoId')).toBe('photo-' + model.get('id'));
    });
  });
});
