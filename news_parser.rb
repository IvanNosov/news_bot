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
  TV_NEWS = 'http://lozovarada.gov.ua/televizijni-novini.html'.freeze

  def main_news
    page = Nokogiri::HTML(open(MAIN_NEWS))
    m = page.css('div.blognews h2 a')
    m.each do |link|
      @links.push "http://lozovarada.gov.ua#{link['href']}"
    end
    @links
  end

  def news
    page = Nokogiri::HTML(open(NEWS))
    m = page.css('div.blognews h2 a')
    m.each do |link|
      @links.push "http://lozovarada.gov.ua#{link['href']}"
    end
    @links
  end

  def tv_news
    page = Nokogiri::HTML(open(TV_NEWS))
    m = page.css('div.blogtv h2 a')
    m.each do |link|
      @links.push "http://lozovarada.gov.ua#{link['href']}"
    end
    @links
  end
end
