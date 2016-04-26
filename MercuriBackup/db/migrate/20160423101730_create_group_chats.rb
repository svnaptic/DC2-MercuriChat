class CreateGroupChats < ActiveRecord::Migration
  def change
    create_table :group_chats do |t|
      t.string :name
      t.timestamps null: false
    end
  end
end
