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
 
  # return a hash of winners
  def getGameWinners
      games = Game.where(week_id: session[:currentWeek])
      winners = Hash.new
      games.each do |g|
        # only put winners in the has
          if g.winning_team_id > 0
              winners[g.winning_team_id] = 1
          end
      end
      return winners
  end

  # flatten the results into a hash
  def flattenResults(results)
      userid = -100
      grouped = Array.new
      picks = Array.new
      slipnum = -1
      logger.debug "results size " + results.size.to_s
      results.each_with_index do |r, index|
          if userid != r.user_id || slipnum != r.slipnum
              # don't push first result but push and start new one
              if userid != -100
                  grouped.push(picks)
              end
              picks = Array.new
              userid = r.user_id
              slipnum = r.slipnum
          end
          picks.push(r)
                # push last entry
          if index == results.size - 1
              grouped.push(picks)
          end
      end
      return grouped
  end
end
