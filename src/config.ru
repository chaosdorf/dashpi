require 'dotenv/load'
require 'dashing'
require 'sentry-ruby'

Dotenv.load

get_secret('SENTRY_DSN') do |dsn|
    Sentry.init do |config|
        config.dsn = dsn
        config.breadcrumbs_logger = [:sentry_logger, :http_logger]
    end
end

get_secret('DASHING_AUTH_TOKEN') do |auth_token|
  configure do
    set :auth_token, auth_token
  end
end

use Sentry::Rack::CaptureExceptions

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

set :template_languages, %i[html erb haml]
set :show_exceptions, false

run Sinatra::Application
