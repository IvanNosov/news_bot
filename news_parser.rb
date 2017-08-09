require 'rubygems'
require 'telegram/bot'
require 'nokogiri'
require 'open-uri'

# parse
class NewsParser
  attr_reader :links

  def initialize
    @links = []
  end

  MAIN_NEWS = 'http://lozovarada.gov.ua/golovni-novini.html'.freeze
  NEWS = 'http://lozovarada.gov.ua/novini.html'.freeze
  TV_NEWS = 'https://www.youtube.com/channel/UCGwtjtN1-g9ulJhuInb-zhg'.freeze

  def main_news
    page = Nokogiri::HTML(open(MAIN_NEWS))
    page.css('div.blognews h2 a').each do |link|
      @links.push "http://lozovarada.gov.ua#{link['href']}"
    end
  end

  def news
    page = Nokogiri::HTML(open(NEWS))
    page.css('div.blognews h2 a').each do |link|
      @links.push "http://lozovarada.gov.ua#{link['href']}"
    end
  end

  def tv_news
    page = Nokogiri::HTML(open(TV_NEWS))
    page.css('ul.expanded-shelf-content-list h3 a').each do |link|
      @links.push "http://youtube.com#{link['href']}"
    end
  end
end