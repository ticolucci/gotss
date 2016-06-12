class TelegramBot
  def initialize(token)
    @token = token
    @client = Telegram::Bot::Client.new(token, logger: Rails.logger)
  end

  def process_message(raw_update)
    update = Telegram::Bot::Types::Update.new(raw_update)

    update_id = update.update_id
    message = update.message
    user_id = message&.from&.id
    chat_id = message&.chat&.id

    Rails.logger.info "Chat from: #{chat_id}, message: #{message.inspect}"

    case message&.text
    when /\A\/help(\@gotss_bot)?\z/
      send_message(chat_id, "I can only /protect_chat from spoilers.\nSave the /come_back_link <url>\nAnd after the chat is protected, users can try to ask me this: /protect_me")
    when /\A\/protect_chat(\@gotss_bot)?\z/
      ChatRoom.find_or_create_by(telegram_id: chat_id)

      send_message(chat_id, "Chat #{message.chat.title} registered. On next GoT episode I'll kick everyone from this chat... Muahahahahah")
    when /\A\/come_back_link(\@gotss_bot)?\s/
      chat_room = ChatRoom.find_or_create_by(telegram_id: chat_id)
      url = message.text.gsub(/\/come_back_link\s/, '')
      chat_room.update(come_back_link: url)
      send_message(chat_id, "Chat #{message.chat.title} come back link is now set to #{url}")
    when /\A\/protect_me(\@gotss_bot)?\z/
      chat_room_id = ChatRoom.find_or_create_by(telegram_id: chat_id).id
      User.find_or_create_by(chat_room_id: chat_room_id, telegram_id: user_id)
      send_message(chat_id, "I'll try #{message.from.first_name}... But make sure you have a private chat with me (@gotss_bot) so that I send you the come back link when I kick your butt ")
    when /\A\//
      send_message(chat_id, "Can't you read #{message.from.first_name}? I only know how to answer to things described by /help... You will probably be spoiled... BY ME!!! Muahahahahahahah")
      sleep(2)
      send_message(chat_id, "JK :* #{message.from.first_name}")
    end
  end

  def send_message(chat_id, text)
    @client.api.send_message(chat_id: chat_id, text: text)
  end

  def kick_user(chat_id, user_id)
    @client.api.kickChatMember chat_id: chat_id, user_id: user_id
  end

  def unban_user(chat_id, user_id)
    @client.api.unbanChatMember chat_id: chat_id, user_id: user_id
  end

  def kick_all(chat_id, users, come_back_link)
    users.each do |user|
      user_id = user.telegram_id
      kick_user(chat_id, user_id)
      unban_user(chat_id, user_id)
      send_message(user_id, "I'm kicking you so you don't receive spam =)\nCome back later!\n #{come_back_link}")
    end
  end
end
