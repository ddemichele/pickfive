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

      # update user results by looping through all the picks and determining winners and losers
      updateUserResults

      flash[:notice] = "Your changes have been saved successfully."
      flash[:color] = "valid"
      redirect_to action: "index"
  end

  # update all the user results based on the winning entries
  def updateUserResults
      results = Pick.where(week_id: session[:currentWeek]).order("user_id, slipnum")
      groupedpicks = flattenResults(results)
      logger.debug groupedpicks.inspect
      # get the winners in a hash
      winners = getGameWinners

      # delete all the results for a given week and then loop through and enter in the results
      UserResult.where(week_id: session[:currentWeek]).delete_all
      # run the bulk insert
      UserResult.bulk_insert(:user_id, :week_id, :version, :slipnum, :wins, :losses, :winner) do |worker|
        # loop through each of the picks and insert new records with their results
        groupedpicks.each do |picks|
            #loop through all five results and calculate wins and losses to create user result
            wins = 0
            winner = 0
            losses = 0
            picks.each do |p|
                if winners.has_key?(p.team_id)
                  wins += 1
                elsif winners.has_value?(p.team_id)
                  losses += 1
                end
            end
            if wins == 5
                winner = 1
            elsif (wins + losses) == 5
                winner = -1
            end
            worker.add user_id: picks[0].user_id, week_id: picks[0].week_id, version: 0, slipnum: picks[0].slipnum, wins: wins, losses: losses, winner: winner
        end
      end
  end

end
