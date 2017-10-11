class GrouppicksController < ApplicationController
  before_action :load_variables
  helper_method :getFavorite

  def index
      logger.debug "<---------- GROUP PICKS USER ----------------->"      
      results = Gameresult.where(week_id: session[:currentWeek]).order("wins desc, lastname, firstname, slipnum")
      @winners = getGameWinners
      @teams = getTeams
      logger.debug @winners.inspect
      @picks = flattenResults(results)
  end

end
