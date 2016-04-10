# This file is used by Rack-based servers to start the application.

#Tell Faye to load the adapter for the Thin webserver.
Faye::WebSocket.load_adapter('thin')
#Obtain the class for websocket handling as middleware.
require ::File.expand_path('./rack_middleware/dashboard_controller')
use Websocket
require ::File.expand_path('../config/environment', __FILE__)
run Rails.application
