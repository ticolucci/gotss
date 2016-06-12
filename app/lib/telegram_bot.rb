class TelegramBot
  def initialize(token)
    @token = token
    Telegram::Bot::Client.new(token, logger: Rails.logger)
  end

  def process_message(raw_update)
    update = Telegram::Bot::Types::Update.new(raw_update)

    update_id = update.update_id
    message = update.message
    message_id = message.message_id
    chat_id = message.chat.id

    Rails.logger.info "Chat from: #{chat_id}, message: #{message.inspect}, "

    case message.text
    when /\A\/help\z/
      client.api.send_message(chat_id: chat_id, text: "I can only /protect_chat from spoilers")
    when /\A\/protect_chat\z/
      client.api.send_message(chat_id: chat_id, text: "Chat #{message.chat.title} registered. On next GoT episode I'll kick everyone from this chat... Muahahahahah")
    end
    Hash.new
  end

  def send_message(chat_id, text)
    bot_api = Faraday.new(url: "https://api.telegram.org/bot#{@token}/sendMessage")
    bot_api.post do |request|
      request.headers['Content-Type'] = 'application/json'
      request.body = {chat_id: chat_id, text: text}.to_json
    end
  end

  def kick_user(chat_id, user_id)
    bot_api = Faraday.new(url: "https://api.telegram.org/bot#{@token}/kickChatMember")
    bot_api.post do |request|
      request.headers['Content-Type'] = 'application/json'
      request.body = {chat_id: chat_id, user_id: user_id}.to_json
    end
  end

  def unban_user(chat_id, user_id)
    bot_api = Faraday.new(url: "https://api.telegram.org/bot#{@token}/unbanChatMember")
    bot_api.post do |request|
      request.headers['Content-Type'] = 'application/json'
      request.body = {chat_id: chat_id, user_id: user_id}.to_json
    end
  end

  def kick_all(chat_id, user_ids, come_back_link)
    user_ids.each do |user_id|
      send_message(user_id, "I'm kicking you so you don't receive spam =) Comae back later!\n #{come_back_link}")
      kick_user(chat_id, user_id)
      unban_user(chat_id, user_id)
    end
  end
end
