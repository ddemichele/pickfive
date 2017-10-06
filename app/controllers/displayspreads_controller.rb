class DisplayspreadsController < ApplicationController
  before_action :load_variables
  helper_method :getFavorite, :getTeamNameArray, :getSpread

  def index
      logger.debug "<---------- DISPLAY SPREADS ----------------->"
      # load the games for a given week
      @games = Game.where("week_id = ?", session[:currentWeek])
      @teams = getTeams
  end
end
