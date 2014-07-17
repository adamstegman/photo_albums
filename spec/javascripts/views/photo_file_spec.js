describe('PhotoAlbums.PhotoFile', function() {
  beforeEach(function() {
    PhotoAlbums.reset();
  });

  describe('change event', function() {
    var subject = function(file) {
      var event = {target: {files: [file]}};
      view.change(event);
    };

    var controller, method, fileContents, fileMetadata;
    beforeEach(function() {
      method = undefined;
      fileContents = undefined;
      fileMetadata = undefined;
      controller = jasmine.createSpyObj('controller', ['send']);
      controller.send.and.callFake(function(m, c, d) {
        method = m;
        fileContents = new Int8Array(c);
        fileMetadata = d;
      });
    });

    var view;
    beforeEach(function() {
      view = PhotoAlbums.PhotoFile.create({controller: controller});
    });

    it("calls upload on the controller with the file contents", function(done) {
      var contents = "contents";
      var file = new Blob([contents], {type: "some/type"});
      file.name = "some-file";
      subject(file);

      var check = function() {
        if (method) {
          expect(method).toBe('upload');
          for (var i = 0; i < contents.length; i++) {
            expect(fileContents[i]).toBe(contents.charCodeAt(i));
          }
          expect(fileMetadata).toEqual({contentType: "some/type", filename: "some-file"});
          done();
        } else {
          Ember.run.later(this, check, 50);
        }
      };
      check();
    });

    it("shortens a Chrome (Windows)-style path to its basename", function(done) {
      var file = new Blob([""]);
      file.name = "C:\\fakepath\\some-file";
      subject(file);

      var check = function() {
        if (fileMetadata) {
          expect(fileMetadata.filename).toEqual("some-file");
          done();
        } else {
          Ember.run.later(this, check, 50);
        }
      };
      check();
    });

    it("shortens a UNIX-style path to its basename", function(done) {
      var file = new Blob([""]);
      file.name = "/some/path/some-file";
      subject(file);

      var check = function() {
        if (fileMetadata) {
          expect(fileMetadata.filename).toEqual("some-file");
          done();
        } else {
          Ember.run.later(this, check, 50);
        }
      };
      check();
    });
  });
});
