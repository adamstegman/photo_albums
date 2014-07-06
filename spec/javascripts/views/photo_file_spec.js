describe('PhotoAlbums.PhotoFile', function() {
  beforeEach(function() {
    PhotoAlbums.reset();
  });

  describe('change event', function() {
    it("calls upload on the controller with the file contents", function(done) {
      var method, fileContents, fileMetadata;
      var controller = jasmine.createSpyObj('controller', ['send']);
      controller.send.and.callFake(function(m, c, d) {
        method = m;
        fileContents = new Int8Array(c);
        fileMetadata = d;
      });
      var view = PhotoAlbums.PhotoFile.create({controller: controller});

      var contents = "contents";
      var file = new Blob([contents], {type: "some/type"});
      var event = {target: {files: [file]}};
      view.change(event);

      var check = function() {
        if (method) {
          expect(method).toBe('upload');
          for (var i = 0; i < contents.length; i++) {
            expect(fileContents[i]).toBe(contents.charCodeAt(i));
          }
          expect(fileMetadata).toEqual({ContentType: "some/type"});
          done();
        } else {
          Ember.run.later(this, check, 50);
        }
      };
      check();
    });
  });
});
