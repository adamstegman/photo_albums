describe('PhotoAlbums.ApplicationController', function() {
  var controller;

  beforeEach(function() {
    PhotoAlbums.reset();

    controller = testHelper.lookup('controller', 'application');
  });

  it("is uploading when uploads are in progress", function() {
    expect(controller.get('isUploading')).toBeFalsy();
    Ember.run(function() {
      controller.startUploadActivityIndicator('a');
    });
    expect(controller.get('isUploading')).toBeTruthy();
    Ember.run(function() {
      controller.startUploadActivityIndicator('b');
    });
    expect(controller.get('isUploading')).toBeTruthy();
    Ember.run(function() {
      controller.stopUploadActivityIndicator('a');
    });
    expect(controller.get('isUploading')).toBeTruthy();
    Ember.run(function() {
      controller.stopUploadActivityIndicator('b');
    });
    expect(controller.get('isUploading')).toBeFalsy();
  });
});
