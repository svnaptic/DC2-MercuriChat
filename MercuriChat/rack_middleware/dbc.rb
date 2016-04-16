require 'faye/websocket'
require 'rubygems'
require 'cgi'
require 'active_support'
require 'action_controller'

#Calling middleware referenced from: https://groups.google.com/forum/#!topic/faye-users/CEc59_gNgWg
class Websocket

  @@ws = {}
  @online_users = {}

  def initialize(app)
    @app = app
  end


  def call(env)
    #Listen for connection attempt. This is always running.
    if Faye::WebSocket.websocket?(env)
      puts "Request found"
      #Make a Rack request with the environment to get cookies.
      request = Rack::Request.new(env)
      set_decrypt_vars(request)

      #puts @user

      #Make new websocket.
    #t = Thread.new {

   # }
      @@ws[@user] = Faye::WebSocket.new(env)
      puts "Setting up thread for #{@user}"
      puts "#{@user.first_name} #{@user.last_name}"
      @@ws[@user].on :message do |event|
        prepended_data = "#{@user.first_name} #{@user.last_name}: " + "#{event.data}"
        @@ws[@user].send(prepended_data)
      end

      @@ws[@user].on :close do |event|
        p [:close, event.code, event.reason]
        ws = nil
      end

      # Return async Rack response
      @@ws[@user].rack_response

      #t = Thread.new{chat_thread(@user, env)}
      #t.join

    else
      @app.call(env)
    end
  end  

  #REMEMBER TO CLOSE THREAD WHEN SOCKET CLOSES!!!
  def chat_thread(user, env)
    puts "Setting up thread for #{user}"
    puts "#{@user.first_name} #{@user.last_name}"
    @@ws[@user].on :message do |event|
      prepended_data = "#{@user.first_name} #{@user.last_name}: " + "#{event.data}"
      @@ws[@user].send(prepended_data)
    end

    @@ws[@user].on :close do |event|
      p [:close, event.code, event.reason]
      ws = nil
    end

    # Return async Rack response
    @@ws[@user].rack_response
  end

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
  end


  def set_decrypt_vars(request)
    cookie = request.cookies["_MercuriChat_session"]
    key = MercuriChat::Application.secrets.secret_key_base
    decrypt_session_cookie(cookie, key)
  end
end #class




