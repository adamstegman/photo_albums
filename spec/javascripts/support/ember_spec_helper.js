PhotoAlbums.setupForTesting();
PhotoAlbums.injectTestHelpers();

Ember.Test.adapter = Ember.Test.JasmineAdapter.create();

PhotoAlbums.ApplicationAdapter = DS.ActiveModelAdapter.extend();
