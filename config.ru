require 'dashing'

Dotenv.load

configure do
  set :auth_token, ENV['DASHING_AUTH_TOKEN']
end

require 'raven'

use Raven::Rack

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

set :template_languages, %i[html erb haml]
set :show_exceptions, false

run Sinatra::Application
