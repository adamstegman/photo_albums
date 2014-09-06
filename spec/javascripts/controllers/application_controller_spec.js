describe('PhotoAlbums.ApplicationController', function() {
  var controller;

  beforeEach(function() {
    PhotoAlbums.reset();

    controller = testHelper.lookup('controller', 'application');
  });

  it("is uploading when uploads are in progress", function() {
    expect(controller.get('isUploading')).toBeFalsy();

    Ember.run(function() {
      controller.startUpload('a');
    });
    expect(controller.get('isUploading')).toBeTruthy();

    Ember.run(function() {
      controller.startUpload('b');
    });
    expect(controller.get('isUploading')).toBeTruthy();

    Ember.run(function() {
      controller.stopUpload('a');
    });
    expect(controller.get('isUploading')).toBeTruthy();

    Ember.run(function() {
      controller.stopUpload('b');
    });
    expect(controller.get('isUploading')).toBeFalsy();
  });
});
