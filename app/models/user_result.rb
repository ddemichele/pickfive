class UserResult < ActiveRecord::Base
	self.table_name = "user_result"
	belongs_to :user
end
