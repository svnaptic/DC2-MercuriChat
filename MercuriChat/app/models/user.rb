class User < ActiveRecord::Base
  has_many :users
  belongs_to :users
  has_many :chats
  #Straight from Bcrypt Github docs
  # users.password_hash in the database is a :string
  include BCrypt

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end
