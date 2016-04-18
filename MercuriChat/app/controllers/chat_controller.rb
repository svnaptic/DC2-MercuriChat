require 'faye/websocket'
@ws

class ChatController < ApplicationController

  def dashboard
    userlist = []
    User.all.each do |u|
      userlist.push("#{u.first_name} #{u.last_name}")
    end
    gon.users = userlist
  end



end #class
