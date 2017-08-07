#!/usr/bin/env ruby
require_relative '../bot'
telegram = LozovaNewsBot.new('@tst_lz')
while true
  telegram.sync
  telegram.send
  sleep 300
end

