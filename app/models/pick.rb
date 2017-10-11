class Pick < ActiveRecord::Base

	self.table_name = "pick"
	belongs_to :user
end
