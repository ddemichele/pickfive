class GrouppicksController < ApplicationController
  before_action :load_variables
  helper_method :getFavorite

  def index
      logger.debug "<---------- GROUP PICKS USER ----------------->"    

      # check to see if the week is Closed. Redirect if it is open
      if !checkWeekClosed
          redirect_to(:controller => 'gamepicks', :action => 'index')
      end

      results = Gameresult.where(week_id: session[:currentWeek]).order("winner desc, wins desc, lastname, firstname, slipnum")
      @winners = getGameWinners
      @teams = getTeams
      logger.debug @winners.inspect
      @picks = flattenResults(results)
  end

end
