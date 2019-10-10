require 'dotenv/load'
require 'dashing'
require 'raven'

Dotenv.load

if File.file?("/run/secrets/SENTRY_DSN")
    Raven.configure do |config|
        config.server = File.read("/run/secrets/SENTRY_DSN").strip
    end
end

if File.file?("/run/secrets/DASHING_AUTH_TOKEN")
  configure do
    set :auth_token, File.read("/run/secrets/DASHING_AUTH_TOKEN").strip
  end
end

use Raven::Rack

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

set :template_languages, %i[html erb haml]
set :show_exceptions, false

run Sinatra::Application
