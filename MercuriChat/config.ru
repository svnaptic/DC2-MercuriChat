# This file is used by Rack-based servers to start the application.
#Tell Faye to load the adapter for the Thin webserver.

Faye::WebSocket.load_adapter('thin')
use Rack::Config do |env|
env[ActionDispatch::Cookies::SECRET_TOKEN] = Rails.application.secrets.secret_key_base
use ActionDispatch::Cookies
use ActionDispatch::Session::CookieStore, key: '_MercuriChat_session'
end

#Obtain the class for websocket handling as middleware.
require ::File.expand_path('./rack_middleware/dashboard_controller')
use Websocket

require ::File.expand_path('../config/environment', __FILE__)
run Rails.application

