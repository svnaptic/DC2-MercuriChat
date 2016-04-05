require 'bcrypt'

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

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
    @user = User.new(user_params)
    @user.password = params[:password][:password]

    respond_to do |format|
      if @user.save
        format.html { redirect_to chat_path, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: chat_path }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
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
  end

  def check_login(params)
    @user = User.where(email: params[:inputUN]).take
    if @user && @user.password && @user.password == params[:inputPW]
      #Set their session variable to their id. Session variables provide memory to the stateless
      #web. At any time the clients browser accesses session[user], it obtains his public key in
      #the database, a unique identifier which allows the browser to always know who it is.
      session[:user] = @user.id
      redirect_to chat_path
    else
      flash[:error] = "Incorrect username or password. Please try again."
    end #if/else
  end

  ##From bcrypt gem
  def login_attempt(email, password)
    @user = User.find_by_email(email)
    if @user.password == password
      #Set their session variable or something
    else
      redirect_to sign_in_path
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
