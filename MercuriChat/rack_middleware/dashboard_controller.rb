require 'faye/websocket'
require 'rubygems'
require 'cgi'
require 'active_support'
require 'action_controller'

#Calling middleware referenced from: https://groups.google.com/forum/#!topic/faye-users/CEc59_gNgWg
class Websocket
  ###############################################################################
  @@ws = {}
  @@talking_to = {}
  @@channels = {}
  @online_users = {}

  ###############################################################################
  # All rack middleware automatically runs an initialize function.              #
  ###############################################################################
  def initialize(app)
    @app = app
  end

  ###############################################################################
  #  Call is an infinite loop using
  ###############################################################################
  def call(env)
    #Listen for connection attempt. This is always running.
    if Faye::WebSocket.websocket?(env)
      puts "Request found"
      #Make a Rack request with the environment to get cookies.
      request = Rack::Request.new(env)
      set_decrypt_vars(request)
      user = @user.id
      @@ws[user] = Faye::WebSocket.new(env)
      #Figure out whose socket we're talking to.
      set_friends(user)

      #Actions if recieve a message:
      @@ws[user].on :message do |event|
        data = "#{User.find(user).first_name} #{User.find(user).last_name}" + ": #{event.data}"
        prepended_data = "#{@@channels[user]} #& "+ data
        #Send data to all friends in conversation.
        send_msg_friend(user, data, prepended_data)
        #And send the data to yourself.
        @@ws[user].send(prepended_data) if @@ws && @@ws[user]
      end

      #Actions for if a user closes the socket.
      @@ws[user].on :close do |event|
        p [:close, event.code, event.reason]
        @@ws.delete(@user)
        @@channels.delete(@user)
      end

      # Return async Rack response
      @@ws[user].rack_response

    else
      @app.call(env)
    end
  end
  ###############################################################################
  #  Rails cookie decryption taken from:                                        #
  #  https://gist.github.com/profh/e36e5dd0bec124fef04c                         #
  #  Function: Decrypt and authenticate Rails session variables.                #
  ###############################################################################
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
    conversation = decrypted_cookie.split("conversation")[1].split(':')[1].split('}')[0] if decrypted_cookie.split("conversation")[1]
    @talking = []
    @talking = conversation.split('*') if conversation
    @user = User.find(user)
    @@channels[@user.id] = decrypted_cookie.split("channel")[1].split(':')[1].split(',')[0].split('}')[0].gsub!(/[" ']/, '')
  end

  ###############################################################################
  # HI
  ###############################################################################
  def set_decrypt_vars(request)
    cookie = request.cookies["_MercuriChat_session"]
    key = MercuriChat::Application.secrets.secret_key_base
    decrypt_session_cookie(cookie, key)
  end

  ###############################################################################
  #
  #  Reference: Stack overflow for getting rid of hidden characters.            #
  #  http://stackoverflow.com/questions/21446369/deleting-all-special-          #
  #  characters-from-a-string-ruby                                              #
  ###############################################################################
  def set_friends(user)
    @@talking_to[user] = []
    @talking.each do |friend|
      if friend.to_i == 0
        formatted_friend = friend.gsub!(/[^0-9A-Za-z]/, '').to_i
      else
        formatted_friend = friend.to_i
      end
      return if formatted_friend == 0
      @@talking_to[user].push(formatted_friend)
  end #do
  end #def

  ###############################################################################
  # Describe
  ###############################################################################
  def send_msg_friend(user, data, prepended_data)
    db_chat = Chat.create(conversation: data, sender_id: user, channel_name: @@channels[user])
    ChatlogEntry.create(user_id: user, chat_id: db_chat.id, read: true)
    @@talking_to[user].each do |friend_id|
    puts
    puts "#{User.find(user).last_name} transmitting to #{User.find(friend_id).last_name}"
    puts "Transmission attempted." if @@ws[friend_id]
    puts "Friend offline." if !@@ws[friend_id]
    puts
    ChatlogEntry.create(user_id: friend_id, chat_id: db_chat.id, read: false )
    @@ws[friend_id].send(prepended_data) if @@ws[friend_id]
  end #do
  end #def
  ###############################################################################

end #class




