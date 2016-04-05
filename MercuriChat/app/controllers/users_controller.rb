class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
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
    @user = User.find(params[:id])
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
    @user.password = params[:password]

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
        # Referenced from: https://www.railstutorial.org/book/log_in_log_out
        # flash.now[:danger] = 'Invalid email/password combination'
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
    @user = User.where(email: params[:inputUN]).take
    if @user && @user.password && @user.password == params[:inputPW]
      #Set their session variable to their id
      session[user] = @user.id
      # log_in user
      redirect_to @user
      # redirect_to @current_user
    else
      puts @user
      puts params[:inputPW]
      puts params[:username]
      puts params[:password]
      # NOTE: I got errors when I had line 92.
      # puts @user.password == params[:inputPW] if @user.password && params[:inputPW]
      session[:error] = "Incorrect username or password. Please try again."
    end
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
