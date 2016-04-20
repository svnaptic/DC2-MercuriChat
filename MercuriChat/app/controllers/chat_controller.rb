require 'faye/websocket'
@ws

class ChatController < ApplicationController

  def dashboard
    userlist = []
    @friendlist = []
    me = User.find(session[:user])
    friends = me.friendships  #.where(status: "friends")
    friends.each do |friend|
      @friendlist.push(User.find(friend.friend_id))
    end
    User.all.each do |u|
      userlist.push("#{u.first_name} #{u.last_name}")
    end
    session["conversation"] = params["conversation"] if params["conversation"]
    gon.users = userlist
  end

end #class
