# frozen_string_literal: true

require 'dotenv/load'
require 'rack'
require 'rack/cors'
require_relative 'config/application'
require_relative 'config/database'
require_relative 'config/routes'

Database.connect

use Rack::Deflater
use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: %i[get post head options]
  end
end
use Rack::Static,
    root: 'public',
    urls: ['/AUTHORS', '/openapi.yaml'],
    header_rules: [
      ['AUTHORS', { 'cache-control' => 'max-age=86400' }],
      ['openapi.yaml', { 'cache-control' => 'no-cache' }]
    ]
run FudoChallenge::Application.new
