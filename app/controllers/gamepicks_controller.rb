class GamepicksController < ApplicationController
  before_action :load_variables
  helper_method :getFavorite

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
          SavePicksMailer.send_pick_confirmation(@current_user, getTeamNameArray(teams, teamHash), session[:currentWeek], session[:slipnum]).deliver_now
          redirect_to action: "index"
        end
      end
  end

  # determine favoriteand return a two team array of favorite and then underdog team id
  def getFavorite(game)
    if game.spread < 0
        return [game.home_team_id, "home", game.vis_team_id, "vis"]
    else
        return [game.vis_team_id, "vis", game.home_team_id, "home"]
    end
  end

  # get the list of team names from 
  def getTeamNameArray(picks, teams)
      teamNames = Hash.new
      picks.each do |pickid|
        teamNames[pickid.to_i] = teams[pickid.to_i].name
      end
      return teamNames
  end
end
