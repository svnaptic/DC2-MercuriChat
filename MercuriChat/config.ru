# This file is used by Rack-based servers to start the application.
#Tell Faye to load the adapter for the Thin webserver.
require 'faye'
require File.expand_path('../rack_middleware/dashboard_controller.rb', __FILE__)
require File.expand_path('../rack_middleware/dbc.rb', __FILE__)

if defined?(PhusionPassenger)
  PhusionPassenger.advertised_concurrency_level = 0
end

Faye::WebSocket.load_adapter('thin')

use Rack::Config do |env|
env[ActionDispatch::Cookies::SECRET_TOKEN] = Rails.application.secrets.secret_key_base
use ActionDispatch::Cookies
use ActionDispatch::Session::CookieStore, key: '_MercuriChat_session'
end

thin = Faye::RackAdapter.new(:mount => '/faye', :timeout => 25)
run thin

#Obtain the class for websocket handling as middleware.
require ::File.expand_path('./rack_middleware/dashboard_controller')
use Websocket

require ::File.expand_path('../config/environment', __FILE__)
run Rails.application

