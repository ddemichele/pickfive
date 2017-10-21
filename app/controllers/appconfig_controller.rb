class AppconfigController < ApplicationController
  before_action :set_config, only: [:show, :edit, :update, :destroy]
  before_action :load_variables

  def index
    @configs = AppConfig.all
  end

  # GET /appconfig/1/edit
  def edit
  end

  def create
    @config = AppConfig.new(config_params)
    if @config.save
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

  # PATCH/PUT /appconfig/1
  def update
      if @user.update(config_params)
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
    def set_config
      @config = AppConfig.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def config_params
      params.require(:appconfig).permit(:name, :value)
    end
end
