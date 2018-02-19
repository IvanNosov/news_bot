#!/usr/bin/env ruby
require_relative '../bot'
loop do
  telegram = LozovaNewsBot.new('@testlozova')
  telegram.sync
  telegram.send
  sleep 300
end