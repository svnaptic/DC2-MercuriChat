class CreateJoinTable < ActiveRecord::Migration
  def change
    create_join_table :users, :group_chats do |t|
      # t.index [:user_id, :group_chat_id]
      # t.index [:group_chat_id, :user_id]
    end
  end
end
