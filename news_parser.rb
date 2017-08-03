require 'rubygems'
require 'telegram/bot'
require 'nokogiri'
require 'open-uri'

# parse
class NewsParser
  attr_reader :links, :posts

  def initialize
    @links = []
    @posts = []
  end

  MAIN_NEWS = 'http://lozovarada.gov.ua/golovni-novini.html'.freeze
  NEWS = 'http://lozovarada.gov.ua/novini.html'.freeze
  TV_NEWS = 'http://lozovarada.gov.ua/televizijni-novini.html'.freeze

  def main_news
    page = Nokogiri::HTML(open(MAIN_NEWS))
    page.css('div.blognews h2 a').each do |link|
      @links.push "http://lozovarada.gov.ua#{link['href']}"
    end
    page.css('div.blognews [style="text-align: justify;"]').each do |text|
      @posts.push text.text
    end
  end

  def news
    page = Nokogiri::HTML(open(NEWS))
    page.css('div.blognews h2 a').each do |link|
      @links.push "http://lozovarada.gov.ua#{link['href']}"
    end
    page.css('div.blognews [style="text-align: justify;"]').each do |text|
      @posts.push text.text
    end

  end

  def tv_news
    page = Nokogiri::HTML(open(TV_NEWS))
    page.css('div.blogtv h2 a').each do |link|
      @links.push "http://lozovarada.gov.ua#{link['href']}"
    end
    page.css('div.blogtv [itemprop="blogPost"] p').map(&:text).each do |text|
      @posts.push text.to_s.gsub("\n", "")

    end
  end
end

#a = NewsParser.new
# a.main_news
# a.news
# h = Hash[a.links.zip a.posts]
# a.tv_news
# puts a.posts