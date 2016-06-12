class AddChatIdIndexToChatRooms < ActiveRecord::Migration[5.0]
  def change
    add_index :chat_rooms, :telegram_id
  end
end
