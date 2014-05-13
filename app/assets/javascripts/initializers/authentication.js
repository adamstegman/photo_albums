//= require "ember-simple-auth/ember-simple-auth"
//= require "ember-simple-auth/ember-simple-auth-devise"

Ember.Application.initializer({
  name: 'authentication',
  initialize: function(container, application) {
    Ember.SimpleAuth.setup(container, application, {
      authorizerFactory: 'authorizer:devise'
    });
  }
});
