class GamepicksController < ApplicationController
  before_action :load_variables
  helper_method :getFavorite, :getTeamNameArray

  def index
      logger.debug "<---------- GAME PICKS USER ----------------->"
      logger.debug "load index: " + params.inspect
      # load the games for a given week
      @games = Game.where("week_id = ?", session[:currentWeek])
      # get the picks
      @picks = Pick.where(user_id: @current_user.id, week_id: session[:currentWeek], slipnum: session[:slipnum]).pluck(:team_id)
      @teams = getTeams
  end

  def save
      teams = params[:teams]
      if !teams.nil?
        if teams.size != 5
           flash[:notice] = "You must save 5 games. Your changes were not saved."
           flash[:color] = "invalid"
           redirect_to action: "index"
        else
          # delete all the records before saving
          Pick.where(user_id: @current_user.id, week_id: session[:currentWeek], slipnum: session[:slipnum]).delete_all
          # create the pick entries
          teams.each do |teamid|
            pick = Pick.create(user_id: @current_user.id, week_id: session[:currentWeek], team_id: teamid, version: 0, slipnum: session[:slipnum])
          end
          flash[:notice] = "Your changes have been saved successfully."
          flash[:color] = "valid"

          # send an email with the picks
          teamHash = getTeams
          # teams array are the pick ids
          #SavePicksMailer.send_pick_confirmation(@current_user, getTeamNameArray(teams, teamHash), session[:currentWeek], session[:slipnum]).deliver_now
          redirect_to action: "index"
        end
      end
  end
end
