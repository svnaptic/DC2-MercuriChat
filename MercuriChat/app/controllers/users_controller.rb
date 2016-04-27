require 'bcrypt'

class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]
  # before_filter :authenticate_user!

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  def index1
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.where(first_name: params[:find_friend].split[0], last_name: params[:find_friend].split[1]).take if params[:find_friend]
    @user = User.find(params[:id]) if !params[:find_friend]

    if request.xhr?
      me = User.find(session[:user])
      #Create friendship unless it exists.
      friend_request = me.friendships.build(:friend_id => @user.id) unless me.friendships.where(friend_id: @user.id).take
      if friend_request.save
        #Friend added message.
      else
        #Friend not added message.
      end
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    # Creates a new user:
    @user = User.new(user_params)
    @user.password = params[:password][:password]

    respond_to do |format|
      if @user.save
        # Referenced from: http://guides.rubyonrails.org/action_mailer_basics.html#sending-emails
        # Delivers "welcome email" to newly registered users:
        # UserMailer.welcome_email(@user).deliver_later

        # Initializes the session's user with @user.id:
        log_in @user

        # Redirects to the user's dashboard:
        format.html { redirect_to dashboard_path, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: dashboard_path }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
        # Referenced from: https://www.railstutorial.org/book/log_in_log_out
        flash.now[:danger] = 'Invalid email/password combination'
        # render 'new'
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def register
    @user = User.new
  end #register

  def sign_in
    check_login(params) if params[:inputUN]
    # For debugging purposes:
    puts
    puts
    puts "*******************"
    puts "In sign_in: #{params}"
    puts "*******************"
    puts
  end

  # Referenced from: https://www.railstutorial.org/book/log_in_log_out
  # Sets the session's user to the user passed to it:
  def log_in(user)
    session[:user] = user.id
  end

  # Referenced from: https://www.railstutorial.org/book/log_in_log_out
  # Logs out the current user.
  def sign_out
    session[:user] = nil
    redirect_to index_path
  end

  # 
  def is_zero?(index)
    if index == 0
      return true
    else 
      return false
    end
  end

  # Referenced from: https://www.railstutorial.org/book/log_in_log_out
  # Checks to see if the user is currently logged on.
  def signed_in? (user)
    me = User.find(session[:user])

    # For debugging:
    puts
    puts
    puts "****************************"
    puts "Me:   #{me}"
    puts "User: #{user}"
    puts "****************************"
    puts
    puts

    if me != user
      return false
    else
      return true
    end
  end

  # Validates if a user has signed in:
  def check_login(params)
    # For debugging purposes:
    puts
    puts
    puts "*******************"
    puts "#{params}"
    puts "*******************"
    puts

    @user = User.where(email: params[:inputUN]).take
    if @user && @user.password && @user.password == params[:inputPW]
      #Set their session variable to their id. Session variables provide memory to the stateless
      #web. At any time the clients browser accesses session[user], it obtains his public key in
      #the database, a unique identifier which allows the browser to always know who it is.
      log_in @user
      redirect_to dashboard_path
    else
      puts "failed"
      puts params
      print "USER: "
      print "Password Correct ?: "
      puts @user.password == params[:inputPW] if @user
      print "Username: "
      puts params[:inputUN]
      puts params[:password]
      # NOTE: I got errors when I had line 92.
      # puts @user.password == params[:inputPW] if @user.password && params[:inputPW]
      session[:error] = "Incorrect username or password. Please try again."
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password_hash, :password_salt)
  end
end
