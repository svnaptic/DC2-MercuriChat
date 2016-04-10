require 'faye/websocket'

#Middleware referenced from: https://groups.google.com/forum/#!topic/faye-users/CEc59_gNgWg


class Websocket
  def initialize(app)
    @app = app
  end

  def call(env)
    #Listen for connection attempt. This is always running.
    if Faye::WebSocket.websocket?(env)
      ws = Faye::WebSocket.new(env)

      puts "Stream is #{@stream}."

      ws.on :message do |event|
        @user = User.find(1)
        prepended_data = "#{@user.first_name}: " + "#{event.data}"
        ws.send(prepended_data)
      end

      ws.on :close do |event|
        p [:close, event.code, event.reason]
        ws = nil
      end

      # Return async Rack response
      ws.rack_response
    else
      @app.call(env)
    end
  end

end #class




