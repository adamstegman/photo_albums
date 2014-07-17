PhotoAlbums.Album.FIXTURES = [{
  id: "inbox",
  name: "Inbox",
  photos: [1]
}];

PhotoAlbums.Photo.FIXTURES = [{
  id: 1,
  album: "inbox",
  filename: "IMG_2598.jpg",
  contentType: "image/jpeg",
  width: 3264,
  height: 2446,
  latitude: 39.050333,
  longitude: -94.607167,
  takenAt: "2013-05-15T01:55:54Z",
  comment: null,
  blobBucket: "adamstegman-photo-albums-test",
  blobKey: "IMG_2598.jpg",
  session: "adamstegman-photo-albums-test"
}];

PhotoAlbums.BlobSession.FIXTURES = [{
  id: "some-bucket",
  sessionToken: "token",
  accessKeyId: "AKIAIJBD2PEYUG4WXJXQ",
  secretAccessKey: "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"
}];
