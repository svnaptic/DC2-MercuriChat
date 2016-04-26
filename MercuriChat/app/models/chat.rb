class Chat < ActiveRecord::Base
  has_many :users, :through => chatlog_entries
end
