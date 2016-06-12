class BotController < ApplicationController
  before_action :log_error_if_so, only: :index

  def index
    response = TelegramBot.new(BOT_TOKEN).process_message(params)
    render json: { done: :ok }.merge(response)
  end

  def kick_all
    chat_room = ChatRoom.first
    TelegramBot.new(BOT_TOKEN).kick_all(
      chat_room&.telegram_id,
      Array(chat_room&.users).map(&:telegram_id),
      chat_room&.come_back_link
    )
    render json: {done: :ok}
  end

  private

  def log_error_if_so
    unless params.dig('ok')
      Rails.logger.error "[Error] #{params['error_code']}: #{params['description']}"
      render json: { error: :sorry }
    end
  end
end
