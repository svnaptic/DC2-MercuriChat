require 'faye/websocket'
@ws

class ChatController < ApplicationController

  def dashboard
    gon.users = User.all
  end

end #class
