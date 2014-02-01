describe('PhotoAlbums', function() {
  it('should create an Ember Application on window.PhotoAlbums', function() {
    expect(window.PhotoAlbums.get('isNamespace')).toBeTruthy();
  });
});
