class SavePicksMailer < ActionMailer::Base
	default from: 'thepickfive@gmail.com'
  
  	def send_pick_confirmation(user, teams, week, slipnum)
  		@user = user
  		@teams = teams.values
  		@week = week
  		@slipnum = slipnum
  		mail(to: @user.username, subject: "Your picks for Slip " + @slipnum + " and week " + @week + " have been saved.")
  	end
end
