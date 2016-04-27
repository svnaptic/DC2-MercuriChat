require 'faye/websocket'
@ws

class ChatController < ApplicationController

  def dashboard
    @unread = []
    me = User.find(session[:user])
    create_groupchat(me) if params["group_name"]
    init_friends(me)
    init_conversation(me)
    init_groupchats(me)
    init_friendsearch
    me.chatlog_entries.where(read: false ).each do |unread|
      @unread.push(Chat.find(unread.chat_id).channel_name)
    end #do
    @unread = @unread.uniq
    respond_to do |format|
      format.html
      format.js
    end
  end #dashboard

  def loadmore
    gon.start += 10 if gon.start
    gon.start = 10 if !gon.start
    get_chats(User.find(session[:user]), gon.start, gon.start + 10)
    respond_to do |format|
      format.js and return
    end
  end

  ###############################################################################
  #  init_friends takes as a parameter the current user's ID  and initializes   #
  #  the @friendlist instance variable and the conversation session variable.   #
  #  --@friendlist is an array populated with Activerecords for each of the     #
  #    user's friends.                                                          #
  ###############################################################################
  def init_friends(me)
    @friendlist = []
    friends = me.friendships  #.where(status: "friends")
    friends.each do |friend|
      @friendlist.push(User.find(friend.friend_id))
    end #do
  end #def

  ###############################################################################
  #  init_conversation initializes session[conversation], which is stored in    #
  #  the user's browser cookies.                                                #
  #  --session["conversation"] is a Rails session variable, encrypted and       #
  #    authenticated, which stores a string listing the ID's of the users       #
  #    involved in the user's current conversation, so the server knows which   #
  #    websocket(s) to forward the message to.                                  #
  ###############################################################################
  def init_conversation(me)
    if params["conversation_group"]
      setup_group_conversation(me)
    else
      setup_private_conversation
    end #if
    gon.channel = session["channel"]
    create_gon_chatlog(me)
    #Fix chatlog entries to read if you've clicked on that chat.
    records = me.chats.where(channel_name: session["channel"])
    records.each do |record|
      record.chatlog_entries.where(read: false).each do |entry|
        puts "*** #{entry} ***"
        entry.read = true
        entry.save
        end #do
    end #do
  end # def
  ###############################################################################
  ###############################################################################
  def setup_group_conversation(me)
    memstr = ""
    session["channel"] = GroupChat.find(params["conversation_group"]).name
    members = GroupChat.find(params["conversation_group"]).users
    members.each do |member|
      memstr  += "#{member.id}*" unless member.id == me.id
    end #do
    session["conversation"] = memstr
  end #def
  ###############################################################################
  ###############################################################################
  def setup_private_conversation()
    session["conversation"] = params["conversation_single"]
    if params["conversation_single"].to_i < session["user"].to_i
      session["channel"] = "#{params["conversation_single"]}" + "~" + "#{session["user"]}"
    else
      session["channel"] = "#{session["user"]}" + "~" + "#{params["conversation_single"]}"
    end #if/else
  end #def
  ###############################################################################
  ###############################################################################
  def create_gon_chatlog(me)
    gon.chatlog = []
    gon.chatlogdate = []
    n = 10
    chats = me.chats.where(channel_name: session["channel"]).to_a.sort_by{|a| a.created_at }
    n = chats.size if chats.size < 11
    for i in 0..n
      gon.chatlog[i] = chats[i].conversation if chats[i]
      gon.chatlogdate[i] = chats[i].created_at.httpdate if chats[i]
    end
  end
  ###############################################################################
  #  init_groupchats takes as a parameter the current user's ID and initializes #
  #  the @groupchat_list instance variable for the main dashboard page.         #
  #  --@groupchat_list is an array populated with Activerecords for each of the #
  #  user's group chats.                                                        #
  ###############################################################################
  def init_groupchats(me)
    @groupchat_list = []
    me.group_chats.each do |group_chat|
      @groupchat_list.push(group_chat)
    end #do
  end #def

  ###############################################################################
  #  init_friendsearch returns gon.users, an instance of all users in the       #
  #  database in a Javascript-readable format, using the Gon gem for language   #
  #   conversion.                                                               #
  ###############################################################################
  def init_friendsearch
    userlist = []
    User.all.each do |u|
      userlist.push("#{u.first_name} #{u.last_name}")
    end #do
    gon.users = userlist
  end #def

  ###############################################################################
  #  groupchat takes as a parameter the current user's ID and the params hash   #
  #  from the "new group chat" modal window in dashboard.html.erb. It creates   #
  #  a group chat with the name and users submitted in the form unless the      #
  #  creator of the group is already a member of a group chat bearing that      #
  #  name, in which case it displays an error message.                          #
  ###############################################################################
  def create_groupchat(me)
    group = me.group_chats.where(name: params["group_name"]).take
    if group
      flash[:notice] = "Unable to create group. #{params["group_name"]} already exists."
    else
      group = GroupChat.create(name: params["group_name"])
      group.users << me
      params["members"].each do |member|
        new_member = User.find(member)
        group.users << new_member
      end #do
    end #if/else
  end #groupchat
##########################################################################
  def get_chats(me, start, fin)
    gon.watch.chatlog = 5
    gon.watch.chatlogdate = []
    chats = me.chats.where(channel_name: session["channel"]).to_a.sort_by{|a| a.created_at }
    fin = chats.size if chats.size < fin
    for i in start..fin
      #gon.watch.chatlog[i - start] = chats[i].conversation if chats && chats[i]
      #gon.watch.chatlogdate[i - start] = chats[i].created_at.httpdate if chats[i]
    end #for
  end #def
end #class
