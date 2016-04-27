class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.text :conversation
      t.integer :sender_id
      t.string :channel_name
      t.timestamps null: false
    end
  end
end
