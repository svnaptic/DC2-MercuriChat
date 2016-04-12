require 'faye/websocket'
require 'rubygems'
require 'cgi'
require 'active_support'
require 'action_controller'

#Calling middleware referenced from: https://groups.google.com/forum/#!topic/faye-users/CEc59_gNgWg
class Websocket

  def initialize(app)
    @app = app
  end


  def call(env)
    #decrypt_session_cookie came from https://gist.github.com/pdfrod/9c3b6b6f9aa1dc4726a5#file-decode_session_cookie-rb-L23,
    # His code is similar to the code at:
    def decrypt_session_cookie(cookie, key)
      cookie = CGI::unescape(cookie)

      # Default values for Rails 4 apps
      key_iter_num = 1000
      salt         = MercuriChat::Application.config.action_dispatch.encrypted_cookie_salt    # "encrypted cookie"
      signed_salt  = MercuriChat::Application.config.action_dispatch.encrypted_signed_cookie_salt # "signed encrypted cookie"

      key_generator = ActiveSupport::KeyGenerator.new(key, iterations: key_iter_num)
      secret = key_generator.generate_key(salt)
      sign_secret = key_generator.generate_key(signed_salt)

      encryptor = ActiveSupport::MessageEncryptor.new(secret, sign_secret, serializer: ActiveSupport::MessageEncryptor::NullSerializer)
      #puts Marshal.load(encryptor.decrypt_and_verify(cookie))
      user = encryptor.decrypt_and_verify(cookie).split("user")[1].split(':')[1].split('}')[0]
      @user = User.find(user)
      puts @user
    end

    def set_decrypt_vars(request)
      cookie = request.cookies["_MercuriChat_session"]
      key = MercuriChat::Application.secrets.secret_key_base
      decrypt_session_cookie(cookie, key)
    end

    @ws = {}

    #Listen for connection attempt. This is always running.
    if Faye::WebSocket.websocket?(env)
      #Make a Rack request with the environment to get cookies.
      request = Rack::Request.new(env)
      set_decrypt_vars(request)

      #Make new websocket.
      @ws[@user] = Faye::WebSocket.new(env)

      #Get an ActionDispatch instance so we can get the encrypted session variable from the
      #cookie.

      @ws[@user].on :message do |event|
        prepended_data = "#{@user.first_name} #{@user.last_name}: " + "#{event.data}"
        @ws[@user].send(prepended_data)
      end

      @ws[@user].on :close do |event|
        p [:close, event.code, event.reason]
        ws = nil
      end
    
      # Return async Rack response
      @ws[@user].rack_response
    else
      @app.call(env)
    end
  end

end #class




