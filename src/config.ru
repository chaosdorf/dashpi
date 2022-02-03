require 'dotenv/load'
require 'dashing'
require 'sentry-ruby'

Dotenv.load

if File.file?("/run/secrets/SENTRY_DSN")
    Sentry.init do |config|
        config.dsn = File.read("/run/secrets/SENTRY_DSN").strip
        config.breadcrumbs_logger = [:sentry_logger, :http_logger]
    end
end

if File.file?("/run/secrets/DASHING_AUTH_TOKEN")
  configure do
    set :auth_token, File.read("/run/secrets/DASHING_AUTH_TOKEN").strip
  end
end

use Sentry::Rack::CaptureExceptions

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

set :template_languages, %i[html erb haml]
set :show_exceptions, false

run Sinatra::Application
