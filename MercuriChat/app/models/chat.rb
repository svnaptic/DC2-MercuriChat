class Chat < ActiveRecord::Base
  has_many :chatlog_entries
  has_many :users, :through => :chatlog_entries
end
