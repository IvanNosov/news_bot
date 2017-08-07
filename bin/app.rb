#!/usr/bin/env ruby
require_relative '../bot'
while true
  telegram = LozovaNewsBot.new('@lozova_news')
  telegram.sync
  telegram.send
  sleep 300
end

