workers Integer(ENV["WEB_CONCURRENCY"] || 3)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

env_port        = ENV['PORT']     || 3000
env_environment = ENV['RACK_ENV'] || 'development'
rackup      DefaultRackup
port        env_port
environment env_environment

if env_environment == 'development'
  ssl_bind(
    '127.0.0.1',
    env_port,
    key: File.expand_path('../server.key', __FILE__),
    cert: File.expand_path('../server.crt', __FILE__),
  )
end

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end
