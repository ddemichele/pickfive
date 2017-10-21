class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :load_variables
  # GET /users
  # GET /users.json
  def index
    @users = User.all
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
    p = user_params
    unless p["password"].blank?
      p["password"] = Digest::SHA256.hexdigest(p["password"])
    end
    @user = User.new(p)
    # set the required vars
    @user.setRequiredVars
    if @user.save(p)
      flash[:notice] = "Your changes have been saved successfully."
      flash[:color] = "valid"
      redirect_to action: "index"
    else
      sErr = ""
      user.errors.full_messages.each do |message|
        sErr = sErr + " " + message
      end
      flash[:notice] = sErr
      flash[:color] = "invalid"
      redirect_to action: "index"
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
      p = user_params
      # check the passwords. If the passwords are different then encrypt the password and store
      if @user.password != p["password"]
        unless p["password"].blank?
          p["password"] = Digest::SHA256.hexdigest(p["password"])
        end
      end
      if @user.update(p)
        flash[:notice] = "Your changes have been saved successfully."
        flash[:color] = "valid"
        redirect_to action: "edit"
      else
        sErr = ""
        user.errors.full_messages.each do |message|
          sErr = sErr + " " + message
        end
        flash[:notice] = sErr
        flash[:color] = "invalid"
        redirect_to action: "edit"
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:firstname, :password, :lastname, :slips, :username)
    end
end
