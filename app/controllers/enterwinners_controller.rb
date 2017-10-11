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
      # loop through each of the picks and insert new records with their results
      groupedpicks.each do |picks|
          #loop through all five results and calculate wins and losses to create user result
          userresult = UserResult.new
          userresult.user_id = picks[0].user_id
          userresult.week_id = picks[0].week_id
          userresult.slipnum = picks[0].slipnum
          wins = 0
          winner = 0
          losses = 0
          picks.each do |p|
              if 
          end
          #picks = UserResult.create(user_id: p.user_id, week_id: p.week_id, version: 0, slipnum: p.slipnum, wins: p.wins, losses: p.losses, winner: 0)
      end
  end

end
