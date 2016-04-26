class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.text :conversation
      t.integer :sender_id
      t.string :channel_name #this is nil unless it's a group chat.
      t.timestamps null: false
    end
  end
end
