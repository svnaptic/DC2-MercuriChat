require 'faye/websocket'
require 'rubygems'
require 'cgi'
require 'active_support'
require 'action_controller'

#Calling middleware referenced from: https://groups.google.com/forum/#!topic/faye-users/CEc59_gNgWg
class Websocket

  @@ws = {}
  @@talking_to = {}
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
      user = @user.id
      #Delete if user.id has more than one open socket.
      @@ws[user] = Faye::WebSocket.new(env)
      #Figure out whose socket we're talking to.
      set_friends(user)

      #Actions if recieve a message:
      @@ws[user].on :message do |event|
        prepended_data = "#{User.find(user).first_name} #{User.find(user).last_name}" + ": #{event.data}"
        #Send data to all friends in conversation.
        send_msg_friend(user, prepended_data)
        #And send the data to yourself.
        @@ws[user].send(prepended_data) if @@ws && @@ws[user]
      end

      @@ws[user].on :close do |event|
        p [:close, event.code, event.reason]
        @@ws.delete(@user)
      end

      # Return async Rack response
      @@ws[user].rack_response

    else
      #[200, {'Content-Type' => 'text/plain'}, ['Hello']]
      @app.call(env)
    end
  end

  #Rails cookie decryption referenced from: https://gist.github.com/profh/e36e5dd0bec124fef04c
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
    puts encryptor.decrypt_and_verify(cookie)
    decrypted_cookie = encryptor.decrypt_and_verify(cookie)
    user = decrypted_cookie.split("user")[1].split(':')[1].split(',')[0]
    conversation = decrypted_cookie.split("conversation")[1].split(':')[1].split('}')[0]
    @talking = conversation.split('*') if conversation
    @user = User.find(user)
  end


  def set_decrypt_vars(request)
    cookie = request.cookies["_MercuriChat_session"]
    key = MercuriChat::Application.secrets.secret_key_base
    decrypt_session_cookie(cookie, key)
  end

  def set_friends(user)
  @talking.each do |friend|
    formatted_friend = friend.gsub!(/[^0-9A-Za-z]/, '').to_i
    puts "FRIEND: #{formatted_friend}"
    @@talking_to[user] = formatted_friend
    puts "INIT: #{User.find(user).last_name} is talking to #{User.find(@@talking_to[user]).last_name}."
  end #do
  end #def

  def send_msg_friend(user, prepended_data)
  @talking.each do |friend|
    #Stack overflow for getting rid of hidden characters.
    #http://stackoverflow.com/questions/21446369/deleting-all-special-characters-from-a-string-ruby


    #formatted_friend = friend.gsub!(/[^0-9A-Za-z]/, '').to_i
    #if formatted_friend == 0
      formatted_friend = @@talking_to[user]
    #else
    #  @@talking_to[user] = formatted_friend
    #end
    @@ws[formatted_friend].send(prepended_data) if @@ws[formatted_friend]
  end #do
  end #def

end #class




