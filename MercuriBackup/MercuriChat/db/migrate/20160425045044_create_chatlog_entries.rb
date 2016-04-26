class CreateChatlogEntries < ActiveRecord::Migration
  def change
    create_table :chatlog_entries do |t|
      t.integer :user_id
      t.integer :chat_id
      t.boolean :read
      t.timestamps null: false
    end
  end
end
