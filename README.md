# Photo Albums

A webapp to view photos and organize them into albums.

And a learning experience for me to play with [Ember][].

[Ember]: http://emberjs.com/

## Development

Set up your environment by installing all the dependencies:

```
brew bundle
bundle install
npm install -g bower
bower install
```

Then run `foreman start -f Procfile.dev` to launch the server at [http://localhost:3000/](http://localhost:3000/).

Run all the tests with `bundle exec rake`.
Run individual Ruby tests with `bundle exec rspec spec/...`.
Run JavaScript tests by going to [http://localhost:8888/](http://localhost:8888/).

### Feature tests

Note that feature tests will not work until you have set up an AWS account.
Set up the same environment variables as in deployment, but additionally include:

* `TEST_ACCESS_KEY_ID`
* `TEST_SECRET_ACCESS_KEY`

The purpose of these keys is to separate uploading and downloading permissions, but that is not necessary.

## Deployment

Deployed on [Heroku]() using the [multi-buildpack]() according to [these instructions]().

You'll need to create the following environment variables:

* `AWS_REGION`
* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`

[Heroku]: http://heroku.com
[multi-buildpack]: https://github.com/ddollar/heroku-buildpack-multi
[these instructions]: https://coderwall.com/p/6bmygq
