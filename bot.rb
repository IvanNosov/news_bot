require 'telegram/bot'
require 'sdbm'
require 'json'
require 'logger'
require 'pg'
require 'shorturl'
require_relative 'news_parser'

# telegram bot
class LozovaNewsBot

  def initialize(channel)
    @logger = Logger.new(STDOUT)
    if ENV['TELEGRAM_BOT_API_KEY'].nil?
      @logger.fatal 'Environment variable TELEGRAM_BOT_API_KEY not set!'
      exit 0
    else
      @token = ENV['TELEGRAM_BOT_API_KEY']
    end
    @channel = channel
    uri = URI.parse(ENV['DATABASE_URL'])
    @db = PG.connect(uri.hostname, uri.port, nil, nil, uri.path[1..-1], uri.user, uri.password)
    # @db = PG.connect('localhost', 5432, nil, nil, nil, 'postgres', '1')
    @db.exec('CREATE TABLE IF NOT EXISTS posts (id serial, url varchar(450) NOT NULL, sended bool DEFAULT false)')
  end

  def sync
    parser = NewsParser.new
    parser.main_news
    parser.news
    parser.tv_news
    parser.ads
    parser.links.each do |href|
      h = ShortURL.shorten(href, :shorl)
      if @db.exec("SELECT exists (SELECT 1 FROM posts WHERE url = '#{h}' LIMIT 1)::int").values[0][0].to_i == 1
        @logger.info 'Post exist in DB will not rewrite'
      else
        @logger.info "Write post to DB #{h}" if @db.exec("INSERT INTO posts (url) VALUES ('#{h}')")
      end
    end
  end

  def send
    urls = @db.exec('SELECT url FROM posts WHERE sended = false')
    urls.each do |url|
      if telegram_send(url['url'])
        @db.exec("UPDATE posts SET sended = true WHERE url = '#{url['url']}'")
      end
    end
  end

  private

  def telegram_send(message)
    Telegram::Bot::Client.run(@token) do |bot|
      next if (message == '')
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
