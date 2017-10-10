class EnterwinnersController < ApplicationController
  before_action :load_variables
  helper_method :getFavorite, :getTeamNameArray

  def index
      logger.debug "<---------- ENTER WINNERS ----------------->"
      # load the games for a given week
      @games = Game.where("week_id = ?", session[:currentWeek])
      @teams = getTeams
      @teamdropdown = Team.order(:name).all
  end

  def save
      # loop through and get the games and update the records
      gameids = Hash.new
      params.each do |key|
        if key.starts_with?("winning_team_")
              gameids[key[13..-1].to_i] = {"winning_team_id" => params[key]}
        end
      end 
      if gameids.any?
        Game.update(gameids.keys, gameids.values)
      end

      flash[:notice] = "Your changes have been saved successfully."
      flash[:color] = "valid"
      redirect_to action: "index"
  end
end
