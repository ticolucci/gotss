class CreateChatRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :chat_rooms do |t|
      t.string :name
      t.string :telegram_id
      t.string :come_back_link

      t.timestamps
    end
  end
end
