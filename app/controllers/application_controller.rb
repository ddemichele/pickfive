class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :getSpread, :getTeams

  protected
  @user_slips
  @current_week

  logger.debug "<!----------- APPLICATION CONTROLLER ----------->"
  def authenticate_user
    logger.debug "<-------------- AUTHENTICATE USER --------------->"
  	unless session[:user_id]
  		redirect_to(:controller => 'sessions', :action => 'login')
  		return false
  	else
      self.load_variables
      # check to see if current user is on the session. If they aren't then load all the session variables
      #if session[:currentuser]
      #    @current_user = session[:currentuser]
      #else
          # set current_user by the current user object
      #    @current_user = User.find session[:user_id]
      #    @current_week = AppConfig.find_by name: "currentweek"
      #    session[:slips] = @current_user
      #    session[:curentweek] = @current_week.value
      #end
      return true
  	end
  end

  def load_variables
      logger.debug "<!----------- LOAD VARIABLES ----------->"
      # set current_user by the current user object
      params.each do |key,value|
          logger.debug "Param #{key}: #{value}"
      end
          @current_user = User.find session[:user_id]
          @current_week = AppConfig.find_by name: "currentweek"
          @user_slips = @current_user.slips
          if params[:weekNumber]
            session[:currentWeek] = params[:weekNumber]
          elsif session[:currentWeek]
            logger.debug "week is on the session"
          else
            session[:currentWeek] = @current_week.value
          end
          #load the slipnumber
          if params[:slipnum]
            session[:slipnum] = params[:slipnum]
          elsif session[:slipnum].nil?
            session[:slipnum] = 1
          end
  end

  #This method for prevent user to access Signup & Login Page without logout
  def save_login_state
    logger.debug "<-------------- SAVE LOGIN STATE --------------->"
    if session[:user_id]
            @current_user = session[:currentuser]
            redirect_to(:controller => 'gamepicks', :action => 'index')
      return false
    else
      return true
    end
  end

  #### HELPER METHODS
  def getSpread(spread)
      if spread == 0
        return "E"
      elsif spread == -50
        return "OFF"
      elsif spread > 0
        return spread * -1
      else
        return spread
      end  
  end

  # get a list of teams off the session or load into a hash
  def getTeams
      teams = Team.order(:name).all
      teamHash = Hash.new
      # get all the teams and store in an array
      teams.each do |t|
        teamHash[t.id] = t
      end
      return teamHash  
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

    # flatten all the user picks results into a hash
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

  # return a hash of winners
  def getGameWinners
      games = Game.where(week_id: session[:currentWeek])
      winners = Hash.new
      pushcount = 50
      games.each do |g|
        # put winners in key and loser in value
          if g.winning_team_id > 0
              if g.winning_team_id == g.home_team_id
                loser = g.vis_team_id
              elsif 
                loser = g.home_team_id
              end
              if g.winning_team_id == 100
                winners[pushcount] = g.home_team_id
                pushcount += 1
                winners[pushcount] = g.vis_team_id
                pushcount += 1
              end
              winners[g.winning_team_id] = loser
          end
      end
      return winners
  end
end




