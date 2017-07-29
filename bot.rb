require 'telegram/bot'
require 'sdbm'
require 'json'
require 'logger'
require 'pg'
require './news_parser'

# telegram bot
class LozovaNewsBot
  def initialize(channel)
    @logger = Logger.new(STDOUT)
    @token = '422425129:AAH3PiFT6MRnnsM9xHgku6NLJU5HPFnEtEo'.freeze


    # if ENV['TELEGRAM_BOT_API_KEY'].nil?
    #   @logger.fatal 'Environment variable TELEGRAM_BOT_API_KEY not set!'
    #   exit 0
    # else
    #   @token = ENV['TELEGRAM_BOT_API_KEY']
    # end

    @channel = channel
    @db = PG.connect(host: 'localhost', port: '5432', dbname: nil, user: 'postgres', password: '1')
    @db.exec('CREATE TABLE IF NOT EXISTS posts (id serial, url varchar(450) NOT NULL, sended bool DEFAULT false)')
  end

  def sync
    parser = NewsParser.new
    parser.main_news
    parser.news
    parser.tv_news
    parser.links.each do |href|
      if @db.exec("SELECT exists (SELECT 1 FROM posts WHERE url = '#{href}' LIMIT 1)::int").values[0][0].to_i == 1
        @logger.info 'Post exist in DB will not rewrite'
      else
        @logger.info "Write post to DB #{href}" if @db.exec("INSERT INTO posts (url) VALUES ('#{href}')")
      end
    end
  end

  def send
    urls = @db.exec('SELECT url FROM posts WHERE sended = false')
    urls.each do |url|
      text = "Новая запись в блоге - #{url['url']}"
      if telegram_send(text)
        @db.exec("UPDATE posts SET sended = true WHERE url = '#{url['url']}'")
      end
    end
  end

  private

  def telegram_send(message)
    Telegram::Bot::Client.run(@token) do |bot|
      if bot.api.sendMessage(chat_id: @channel.to_s, text: message)
        @logger.info "Successfuly send #{message} to telegram!"
        true
      else
        @logger.error "Can not send #{message} to telegram!"
        false
      end
    end
  end
end

