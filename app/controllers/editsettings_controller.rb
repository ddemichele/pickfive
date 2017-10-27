class EditsettingsController < ApplicationController
  before_action :load_variables

  def index
      logger.debug "<---------- EDIT PASSWORD ----------------->"
  end

  def save
      # check to make sure the password fields are the same
      if params[:password] != params[:confirm_password]
        flash[:notice] = "Your passwords are not the same. Try again."
        flash[:color] = "invalid"
      else
        encrypted_password = Digest::SHA256.hexdigest(params["password"])
        @current_user.update(password: encrypted_password)
        flash[:notice] = "Your changes have been saved successfully."
        flash[:color] = "valid"
      end
      
      redirect_to action: "index"
  end
end
